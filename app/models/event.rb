# == Schema Information
#
# Table name: events
#
#  id           :integer(4)      not null, primary key
#  organizer_id :integer(4)      not null
#  title        :string(45)      not null
#  description  :string(255)     not null
#  category_id  :integer(4)      not null
#  date         :string(10)      not null
#  end_date     :string(10)      not null
#  start_time   :integer(4)      not null
#  location_id  :integer(4)      not null
#  cost         :string(4)       not null
#  event_url    :string(255)
#
class Event < ActiveRecord::Base

  urlregex = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  belongs_to :location
  belongs_to :organizer
  belongs_to :category
  validates :title,  :presence => true,
                     :length   => { :maximum => 50 }
  validates :description, :presence => true
                 
  validates :date,  :presence => true
  validates :end_date,  :presence => true
  validates :start_time,  :presence => true
  validates :category_id,  :presence => true
  validates :location_id,  :presence => true
  validates :event_url,  :presence => true,
      :format   => { :with => urlregex }
  
  validates_with EventDateValidator

  def validate_date
    @start = Date.strptime(self.date,"%d/%m/%Y")
    @end = Date.strptime(self.end_date,"%d/%m/%Y")
    errors.add :date, "End Date Must Be Greater Than Start Date" if (@end < @start)
  end

  def short_location
    self.location.location_name.split(",")[0]
  end
  def short_desc
    (self.description.length > 50) ? (self.description[0..49] + '...') : self.description
  end
  def save
    begin
      super
    rescue => e
      redirect_to error_path, :notice => "error; =#{e.message}"
    end
  end

  def self.setnew(params,organizer)
    @event = Event.new(params)
    @event.fixdatesfromdatepicker(params[:date],params[:end_date])

    @event.organizer_id = organizer.id
    return @event
  end
  def fixdatesfromdatepicker(date,end_date)
    self.date=DateTime.strptime(date,"%d/%m/%Y") if self.date.nil?
    self.end_date=DateTime.strptime(end_date,"%d/%m/%Y") if self.end_date.nil?
  end
end
