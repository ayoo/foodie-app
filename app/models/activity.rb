class Activity < ActiveRecord::Base
  attr_reader :resource_name

  default_scope { where("deleted_at is null").order('created_at DESC') }
  scope :recent_ones, lambda { |num| includes(:user).limit(num) }

  belongs_to :user
  belongs_to :streamable, polymorphic: true

  def as_json(options={})
    json_obj = super(options)
    json_obj[:resource_name] =  self.streamable_type.downcase.pluralize
    json_obj
  end

end