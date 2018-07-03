require_relative 'acts_as_broadcaster'

module Janao
  class Engine < ::Rails::Engine
    ActiveRecordNotDefined = Class.new(StandardError)
    
    config.to_prepare do
      if defined?(ApplicationRecord)
        ApplicationRecord.send :include, Janao::ActsAsBroadcaster
      elsif defined?(ActiveRecord::Base)
        ActiveRecord::Base.send :include, Janao::ActsAsBroadcaster
      else
        raise ActiveRecordNotDefined, 'Please consider using Active Record to use this engine'
      end
    end
  end
end
