class ApplicationRecord < ActiveRecord::Base
	include Janao::ActsAsBroadcaster
  self.abstract_class = true
end
