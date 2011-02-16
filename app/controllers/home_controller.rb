class HomeController < ApplicationController
  def index

    @events = Event.find(:all,:conditions => "date >= '#{Date.today}'",:order => "date ASC", :limit => 5)
    @event = Event.find(:first, :conditions => "featured = true")
  rescue => e
       redirect_to(error_path, :notice => "Error: #{e.message}")
  end

  def error

  end

end
