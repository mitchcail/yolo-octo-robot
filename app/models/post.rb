class Post < ActiveRecord::Base

  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  geocoded_by :area
  after_validation :geocode, :if => :area_changed?

end
