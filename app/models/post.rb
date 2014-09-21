class Post < ActiveRecord::Base
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  def distance(latitude, longitude)
    self.distance_from [latitude, longitude]
  end
end
