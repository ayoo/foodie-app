class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  default_scope { where("deleted_at is null") }
  scope :admins, -> { where(is_admin: true) }

  has_many :blogs
  has_many :reviews
  has_many :recipes
  has_many :activities

end
