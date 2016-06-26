module Streamable

  def self.included(base)
    base.instance_eval do
      attr_reader :action
      has_many :activities, as: :streamable
      before_save :check_record_status
      after_save  :create_activity_stream
    end

    base.send :include, InstanceMethods
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def check_record_status
      @action = if self.new_record?
                  'created'
                elsif self.deleted_at_changed? # marked as soft-deleted?
                  'deleted'
                else
                  'updated'
                end
    end

    def create_activity_stream
      self.user.activities.create(action: action, title: title, streamable: self)
    end
  end

  module ClassMethods
    def version
      'v0.01'
    end
  end

end