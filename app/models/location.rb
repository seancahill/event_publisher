# == Schema Information
#
# Table name: locations
#
#  id            :integer(4)      not null, primary key
#  location_name :string(255)     not null
#  geo_lat       :float
#  geo_long      :float
#

class Location < ActiveRecord::Base
  has_many :events
  validates :location_name, :presence => true,
    :uniqueness => true
  validates :geo_lat, :presence => true
  validates :geo_long, :presence => true


end
