class OrganizersController < ApplicationController
   before_filter :authenticate
  def new
    @signed_in_user = current_user
    @organizer_exists = Organizer.find_by_user_id(@signed_in_user.id)
    redirect_to new_event_path if !@organizer_exists.nil?
    @organizer = Organizer.new()
    @organizer.user = @signed_in_user.account
    @locations = Location.all
    @organizer.twitter_handle = "eventsindublin"
  end

  def create
    @organizer = Organizer.new(params[:organizer])
    @locations = Location.all
    @signed_in_user = current_user
    @organizer.user_id = @signed_in_user.id
    @organizer.user = @signed_in_user.account
    respond_to do |format|
      if @organizer.save
        format.html {  UserMailer.welcome_email(@organizer).deliver
          redirect_to(new_event_path, :notice => 'New Organizer successfully created.') }
        format.xml  { render :xml => @organizer, :status => :created, :organizer => @organizer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organizer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    @organizer = Organizer.find(params[:id])
    @locations = Location.all
  end

  def update
    @organizer = Organizer.find(params[:id])
    @locations = Location.all
    if @organizer.update_attributes(params[:organizer])
      flash[:success] = "Profile updated."
      redirect_to events_path
    else
      @title = "Edit user"
      render 'edit'
    end
  end
private

    def authenticate
      deny_access unless signed_in?
      @organizer = Organizer.find_by_user_id(current_user.id)
      unless params[:id].nil?
         routing_error(@organizer) if !(@organizer.id == params[:id].to_i)
      end

    end
end
