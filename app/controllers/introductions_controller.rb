class IntroductionsController < ApplicationController
  def start
    if not params.include? :key and not session.include? :key
      render :file => "#{Rails.root}/public/notyet.html", :layout => false and return
    end

    key = params[:key] || session[:key]
    introduction  = Introduction.find_by_key(key)

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

      #@parent = @sender.introduced_by.to_a[0]
      #@grandparent = @parent.introduced_by.to_a[0]

      @children = @sender.rels(dir: :outgoing)

      render :new and return
    end
  end

  def show
    if params.include? :key
      @sender = @introduction.fr
      render :card, :layout => false
    end
  end

  def create
    filtered_params = introduction_params

    # TODO: should be a transaction

    @sender = Person.find(filtered_params[:sender][:uuid])

    # TODO: ensure logged in user only
    if @sender.nil? or @sender.get_referral_limit - @sender.rels(dir: :outgoing).count <= 0
      render :file => "#{Rails.root}/public/422.html", :status => :unprocessable_entity, :layout => false and return
    end

    @sender.update(filtered_params[:sender])
    @recipient = Person.create()

    @introduction = Introduction.new(from_node: @sender, to_node: @recipient, content: filtered_params[:content])

    if @introduction.valid?
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
    @sender.in_progress = nil

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
      if @introduction.save
        format.html { redirect_to "/#{session.fetch("key", "")}", :flash => { :updated_key => in_progress } }
      else
        format.html { render :confirm }
      end
    end
  end

  def destroy
    @introduction = Introduction.find_by_key(params[:key])
    @sender = @introduction.to_node

    if @sender.in_progress
      @sender.introduced(:person, :intro).rel_where(key: @sender.in_progress).delete_all(:intro)

      @sender.in_progress = nil
      @sender.save

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
    end

    def introduction_params
      params.require(:introduction).permit(:content, :template,
          :sender => [:uuid, :name, :email],
          :recipient => [:uuid, :name, :street_line1, :street_line2, :city, :state, :postal_code, :country])
    end
end
