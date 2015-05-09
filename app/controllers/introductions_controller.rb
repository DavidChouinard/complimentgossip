class IntroductionsController < ApplicationController
  def start
    if params.include? :key
      query = Person.all.introduced(:person, :intro).where('intro.key = {key}').params(key: params[:key])

      introduction = query.pluck(:intro).to_a

      if not introduction.empty?
        @sender = query.pluck(:person).to_a[0]
        @parent_introduction = introduction[0]
        @parent = @parent_introduction.from_node

        if (not session.include? :user_id) or (session.include? :user_id and @sender[:uuid] != session[:user_id])
          session[:introduction] = params[:key]
          session[:user_id] = @sender[:uuid]
        end
      end
    elsif session.include? :user_id
      @sender = Person.find(session[:user_id])
      # TODO: intro, find latest
      # @introduction = ...

      @parent = @sender.introduced_by.to_a[0]
    end

    if not defined? @sender
      @sender = Person.new
    end


    #TODO: check empty

    #@parent = @sender.introduced_by.to_a[0]
    #@grandparent = @parent.introduced_by.to_a[0]

    @recipient = Person.new
    @introduction = Introduction.new

    respond_to do |format|
      #if @sender.introduced.to_a.count >= 1
        #format.html { render :more }
      #else
        format.html { render :new }
      #end
    end
  end

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  def create
    filtered_params = introduction_params

    # TODO: handle UUID no recognized
    # ensure login user only
    @sender = Person.find(filtered_params[:sender][:uuid])
    @sender.update(filtered_params[:sender])
    @recipient = Person.create(filtered_params[:recipient])

    @introduction = Introduction.new(from_node: @sender, to_node: @recipient, content: filtered_params[:content])

    respond_to do |format|
      if @introduction.save
        #format.html { redirect_to "/#{@introduction.key}" }
        @url = "#{request.base_url}/#{@introduction.key}"
        format.html { render :prompt }
      else
        format.html { render :new }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #before_action :set_person, only: [:show, :edit, :update, :destroy]
    #def set_person
      #@person = Person.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def introduction_params
      #TODO: required uuid
      params.require(:introduction).permit(:content, :sender => [:uuid, :full_name, :contact], :recipient => [:given_name])
    end

    #def sender_params
      #puts params
      #params.require(:sender).permit(:uuid, :full_name, :contact)
    #end

    #def recipient_params
      #params.require(:recipient).permit(:given_name)
    #end
end
