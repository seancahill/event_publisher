class UserMailer < ActionMailer::Base
  default :from => "eventsindublin@gmail.com"
  def welcome_email(user)
    @user = user
    @url  = "http://event-publisher.heroku.com"
    
    mail(:to => user.email,
         :subject => "Welcome to the Dublin Event Publisher Web Site")
  end
  def event_email(event,email)
    @event = event
    @url  = "http://event-publisher.heroku.com"
    @eventdetails=@url+"/events/"+event.id.to_s
    mail( :from => event.organizer.email, :to => email,
         :subject => "New Dublin Event Notification")
  end
end
