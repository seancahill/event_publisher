class UserMailer < ActionMailer::Base
  default :from => "info@nmm.ie"
  def welcome_email(user)
    @user = user
    @url  = "http://jobinireland.com/"
    mail(:to => user.email,
         :subject => "Welcome to My Awesome Site")
  end
  def event_email(event,email)
    @event = event
    @url  = "http://jobinireland.com/"

    mail( :from => event.organizer.email, :to => email,
         :subject => "New Event Notification")
  end
end
