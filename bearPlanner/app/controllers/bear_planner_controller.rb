class BearPlannerController < ApplicationController
  #The next three lines require that some method in "application_controller.rb" 
  # be run before certain methods start
  before_filter :login_required, :except => [:signup, :home, :login]
  before_filter :cal_id_matches_user, :except =>[:create_calendar, :signup, :home, :login, :logout, :show_calendars, :show_invites, :show_invite]
  before_filter :invite_id_matches_user, :only=>[:show_invite]
  
  def home
  end

  def signup
    #Attempts to create a new user
    user = Users.new do |u| 
      u.name = params[:username]
      u.password = params[:password]
    end #creates a new instance of the user model
    if request.post? #checks if the user clicked the "submit" button on the form
      if user.save #if they have submitted the form attempts to save the user
        session[:uid] = user.id #Logs in the new user automatically
        redirect_to :action => "show_calendars" #Goes to their new calendars page
      else #This will happen if one of the validations define in /app/models/user.rb fail for this instance.
        redirect_to :action => "signup", :notice=>"An error has occurred." #Ask them to sign up again
      end
    end
  end

  def login
    if request.post? #If the form was submitted
      user = Users.find(:first, :conditions=>['name=?',(params[:username])]) #Find the user based on the name submitted
      if !user.nil? && user.password==params[:password] #Check that this user exists and it's password matches the inputted password
        session[:uid] = user.id #If so log in the user
        redirect_to :action => "show_calendars" #And redirect to their calendars
      else
        redirect_to :action => "login", :notice=> "Invalid username or password. Please try again." #Otherwise ask them to try again. 
      end
    end
  end

  def logout
    session[:uid] = nil #Logs out the user
    redirect_to :action => "home" #redirect to the homepage
  end

  def show_calendars
    @calendarArray = Calendar.all
    
  end

  def show_calendar
    calendar = Calendar.find_by_id(params[:cal_id])

    @calName = calendar.name
    @calDescription = calendar.description
    @eventArray = Event.all
  end

  def edit_event
   begin
   event = Event.find_by_id(params[:event_id])
   calendars = Calendar.all
   @calendars = calendars.collect {|c| [c.name, c.id]}
   if request.post?
       event.name = params[:eventName]
       event.starts_at = params[:starts_at]
       event.ends_at = params[:ends_at]
       event.owner = event.owner
       event.save
       redirect_to :action=>"show_calendar", :cal_id => params[:cal_id]

   end
   @eventName = event.name
   @eventId = event.id
   @eventStarts = event.starts_at
   @eventEnds = event.ends_at
   @eventOwner = event.owner
   @invitees = Hash.new()
   rescue ActiveRecord::RecordNotSaved
      redirect_to "edit_event", :notice=>"An error has occurred.", :cal_id => params[:cal_id], :event_id => params[:event_id]
      render :new
   end
  # params[:old_cal_id] = Event.old_cal_id
  # params[:cal_id] = Event.cal_id
   #params[:invitees] = Event.invitees
   #params[:inviteMessage] = Event.invite_message
 end

  def create_calendar
    begin
    cal = Calendar.new
    if request.post?
     cal.name = params[:calName]
     cal.description = params[:calDescription]
     cal.save
     redirect_to :action => "show_calendar", :cal_id => cal.id
    end
    rescue ActiveRecord::RecordNotSaved
        redirect_to "create_calendar", :notice=>"An error has occurred."
        render :new
     end
  end

  def edit_calendar
    begin
    cal = Calendar.find_by_id(params[:cal_id])
    if request.post?
      cal.name = params[:calName]
      cal.description = params[:calDescription]
      cal.save
      redirect_to :action => "show_calendar", :cal_id => params[:cal_id]
      end
      @calName = cal.name
      @calDescription = cal.description
      rescue ActiveRecord::RecordNotSaved
        redirect_to "edit_calendar", :notice=>"An error has occurred."
        render :new
     end
    
  end

  def delete_calendar
    begin
    cal = Calendar.find_by_id(params[:cal_id])
    if Event.count = 0
      cal.destroy
    end
    end
  end

  def create_event
  end


  def delete_event
  end

  def show_invites
  end

  def show_invite
  end

end
