class Recipe < ActiveRecord::Base
  include Streamable

  belongs_to :user
  default_scope { where("deleted_at is null").order('created_at DESC') }

  validates :title, :content, :user_id, presence: true
end