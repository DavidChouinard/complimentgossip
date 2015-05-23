class IntroductionsController < ApplicationController
  def start
    introduction  = Introduction.find_by_key(params[:key])

    if introduction.nil?
      render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false and return
    end

    @sender = introduction.to_node

    session[:key] = params[:key]

    # TODO: this really should be seperated in two actions
    if @sender.in_progress
      @introduction = Introduction.find_by_key(@sender.in_progress)

      @recipient = @introduction.to_node

      render :confirm and return
    else
      @parent = introduction
      @recipient = Person.new
      @introduction = Introduction.new

      @chain = []

      3.times do |i|
        if i == 0
          @chain[i] = introduction
        else
          if @chain[i - 1].nil?
            break
          else
            parents = @chain[i - 1].from_node.rels(dir: :incoming)
            if not parents.empty?
              @chain[i] = parents[0]
            end
          end
        end
      end

      @chain.reverse!

      @children = @sender.rels(dir: :outgoing).sort { |a,b|
        if flash[:updated_key]
          if flash[:updated_key] == a.key
            next -1
          elsif flash[:updated_key] == b.key
            next 1
          end
        end

        b.created_at <=> a.created_at
      }

      render :new
    end
  end

  def show
    if introduction.nil?
      render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false and return
    end

    @sender = @introduction.from_node
    render :card, :layout => false
  end

  def create
    filtered_params = introduction_params

    # TODO: should be a transaction

    @sender = Person.find(filtered_params[:sender][:uuid])

    # TODO: ensure logged in user only
    if @sender.nil? or @sender.in_progress or @sender.get_referral_limit - @sender.rels(dir: :outgoing).count <= 0
      render :file => "#{Rails.root}/public/422.html", :status => :unprocessable_entity, :layout => false and return
    end

    @sender.update(filtered_params[:sender])
    @recipient = Person.create()

    @introduction = Introduction.new(from_node: @sender, to_node: @recipient, content: filtered_params[:content], template: filtered_params[:template])

    if @introduction.valid?
      @introduction.generate_key
      html = render_to_string :card, :layout => false

      object =  LOB.objects.create(
        description: "Card #{@introduction.key}",
        file: html.to_str,    # to_s is broken
        setting: "201"
      )

      @introduction.obj_id = object["id"]
      @introduction.thumbnail = object["thumbnails"][0]["small"]
      @introduction.image = object["thumbnails"][0]["large"]
    end

    respond_to do |format|
      if @introduction.save
        @sender.update(:in_progress => @introduction.key)
        format.html { redirect_to "/#{session.fetch("key", "")}" }
      else
        format.html { render :new }
      end
    end
  end

  def update
    filtered_params = introduction_params

    @sender = @introduction.from_node

    if @sender.in_progress.blank?
      render :file => "#{Rails.root}/public/422.html", :status => :unprocessable_entity, :layout => false and return
    end

    @recipient = @introduction.to_node

    in_progress = @sender.in_progress

    if not (@sender.update(filtered_params[:sender]) and @recipient.update(filtered_params[:recipient]))
      render :confirm and return
    end

    job = LOB.jobs.create(
      description: "Card #{@introduction.key}",
      from: {
        :name => @sender.name,
        :address_line1 => @sender.street_line1,
        :address_line2 => @sender.street_line2,
        :city => @sender.city,
        :state => @sender.state,
        :country => @sender.country,
        :zip => @sender.postal_code
      },
      to: {
        :name => @recipient.name,
        :address_line1 => @recipient.street_line1,
        :address_line2 => @recipient.street_line2,
        :city => @recipient.city,
        :state => @recipient.state,
        :country => @recipient.country,
        :zip => @recipient.postal_code
      },
      objects: [@introduction.obj_id]
    )

    @introduction.job_id = job["id"]
    @introduction.expected_delivery = Date.parse(job["expected_delivery_date"])

    respond_to do |format|
      if @introduction.save and @sender.update(in_progress: nil)

        #UserMailer.new_card(@sender.introduced_by[0], @introduction, :type => :parent).deliver_now

        format.html { redirect_to "/#{session.fetch("key", "")}", :flash => { :updated_key => in_progress } }
      else
        format.html { render :confirm }
      end
    end
  end

  def destroy
    @sender = @introduction.to_node

    if @sender.in_progress
      @sender.introduced(:person, :intro).rel_where(key: @sender.in_progress).delete_all(:intro)

      @sender.update(in_progress: nil)

      redirect_to "/#{session.fetch("key", "")}"
    else
      render :file => "public/422.html", :layout => false, :status => :unauthorized
    end
  end

  def format_serial(serial = 0)
    if serial == 0
      serial = Person.all.introduced.count + 1
    end

    return "##{serial.to_s.rjust(3, '0')}"
  end
  helper_method :format_serial

  def format_date(date)
    if date.blank?
      return ""
    end

    if date.year == Date.today.year
      return date.strftime("%b %e")
    else
      return date.strftime("%b %e, %Y")
    end
  end
  helper_method :format_date

  private
    before_action :set_introduction, only: [:show, :update, :destroy]
    def set_introduction
      @introduction = Introduction.find_by_key(params[:key])

      # TODO: handle this and report exception
      #if @introduction.nil?
        #render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false and return
      #end
    end

    before_action :redirect_to_key, only: [:start]
    def redirect_to_key
      if not params.include? :key
        if session.include? :key
          redirect_to "/#{session[:key]}"
        else
          render :file => "#{Rails.root}/public/notyet.html", :layout => false and return
        end
      end
    end

    def introduction_params
      params.require(:introduction).permit(:content, :template,
          :sender => [:uuid, :name, :email],
          :recipient => [:uuid, :name, :street_line1, :street_line2, :city, :state, :postal_code, :country])
    end
end
