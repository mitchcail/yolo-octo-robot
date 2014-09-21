class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_one :location

  geocoded_by :current_sign_in_ip
  after_validation :geocode

  geocoded_by :area
  after_validation :geocode, :if => :area_changed?


end
