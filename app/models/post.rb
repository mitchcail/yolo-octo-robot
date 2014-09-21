class Post < ActiveRecord::Base

  belongs_to :user

  geocoded_by :area
  after_validation :geocode, :if => :area_changed?

end
