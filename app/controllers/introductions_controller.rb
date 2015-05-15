class IntroductionsController < ApplicationController
  def start
    # TODO: this really should be seperated in two

    if params.include? :key or session.include? :key

      key = params[:key] || session[:key]
      query = Person.all.introduced(:person, :intro).where('intro.key = {key}').params(key: key.downcase)

      introduction = query.pluck(:intro).to_a

      if not introduction.empty?
        @sender = query.pluck(:person).to_a[0]

        session[:key] = params[:key]
        session[:user_id] = @sender[:uuid]

        if @sender.in_progress
          query = Person.all.introduced(:person, :intro).where('intro.key = {key}').params(key: @sender.in_progress)

          @introduction = query.pluck(:intro).to_a[0]  # TODO: handle empty
          @recipient = query.pluck(:person).to_a[0]

          render :confirm and return
        else
          @parent = introduction[0]
          @recipient = Person.new
          @introduction = Introduction.new

          render :new and return
        end
      else
        render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false and return
      end
    else
      # TODO: not open for business
      render :file => "#{Rails.root}/public/notyet.html", :layout => false and return
    end

    #@parent = @sender.introduced_by.to_a[0]
    #@grandparent = @parent.introduced_by.to_a[0]

    #@sender.in_progress = nil
    #@sender.save()

    #respond_to do |format|
      #if @sender.in_progress
        #format.html { render :confirm }
      #else
        #format.html { render :new }
      #end
    #end
  end

  def show
    if params.include? :key
      render :card, :layout => false
    end
  end

  def create
    filtered_params = introduction_params

    # TODO: handle UUID no recognized
    # ensure login user only

    # TODO: should be a transaction

    @sender = Person.find(filtered_params[:sender][:uuid])
    @sender.update(filtered_params[:sender])
    @recipient = Person.create()

    @introduction = Introduction.new(from_node: @sender, to_node: @recipient, content: filtered_params[:content])

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

    # TODO: check not exists  and in_progress exists
    @recipient = Person.find(filtered_params[:recipient][:uuid])

    # TODO: move this
    in_progress = @sender.in_progress
    @sender.in_progress = nil

    # TODO: validation error
    if not (@sender.update(filtered_params[:sender]) and @recipient.update(filtered_params[:recipient]))
      render :confirm and return
    end

    html = render_to_string :card, :layout => false

    object =  LOB.objects.create(
      description: "Card #{@introduction.key}",
      file: html.to_str,    # to_s is broken
      setting: "201"
    )

    @introduction.obj_id = object["id"]
    @introduction.thumbnail = object["thumbnails"][0]["small"]
    @introduction.image = object["thumbnails"][0]["large"]

    job = LOB.jobs.create(
      description: "Card #{@introduction.key}",
      from: "adr_6de93363a1bc1f9a",  # TODO
      to: {
        :name => @recipient.name,
        :address_line1 => @recipient.street_line1,
        :address_line2 => @recipient.street_line2,
        :city => @recipient.city,
        :state => @recipient.state,
        :country => @recipient.country,
        :zip => @recipient.postal_code
      },
      objects: [object["id"]]
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

  def format_serial(serial = 0)
    if serial == 0
      serial = Person.all.introduced.count + 1
    end

    return "##{serial.to_s.rjust(3, '0')}"
  end
  helper_method :format_serial

  private
    before_action :set_introduction, only: [:show, :update]
    def set_introduction
      # TODO: validation
      query = Person.all.introduced_by(:person, :intro).where('intro.key = {key}').params(key: params[:key])
      @sender = query.pluck(:person).to_a[0]
      @introduction = query.pluck(:intro).to_a[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def introduction_params
      #TODO: require uuid
      params.require(:introduction).permit(:content, :template,
          :sender => [:uuid, :name, :email],
          :recipient => [:uuid, :name, :street_line1, :street_line2, :city, :state, :postal_code, :country])
    end

    #def sender_params
      #puts params
      #params.require(:sender).permit(:uuid, :full_name, :contact)
    #end

    #def recipient_params
      #params.require(:recipient).permit(:given_name)
    #end
end
