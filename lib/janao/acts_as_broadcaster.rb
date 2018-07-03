require 'byebug'
require_relative 'services/services'

module Janao
	module ActsAsBroadcaster
		extend ActiveSupport::Concern

		included do
			def method_missing(symbol, *args, &block)
				case symbol.to_s
					when self.class.broadcast_templates_setter_text_field
						BroadcasterBuilder.build(:set_templates, self, *args)
					when self.class.broadcast_channels_setter_text_field
						BroadcasterBuilder.build(:set_channels, self, *args)
					when self.class.broadcast_method_text_field
						BroadcasterBuilder.build(:broadcast, self, *args)
					else
						super
				end
			end
		end

		class_methods do
			def acts_as_broadcaster(**options)
				cattr_reader :broadcaster_text_field, default: (options[:broadcaster_text_field] || :broadcaster).to_s
				cattr_reader :broadcast_channels_text_field, default: (options[:broadcast_channels_text_field] || :broadcast_channels).to_s
				cattr_reader "#{self.broadcast_channels_text_field}", default:  %i{email sms push}
				cattr_reader :broadcast_channels_setter_text_field, default: (options[:broadcast_channels_setter_text_field] || :set_broadcast_channels).to_s
				cattr_reader :broadcast_templates_text_field, default: (options[:broadcast_templates_text_field] || :broadcast_templates).to_s
				cattr_reader "#{self.broadcast_templates_text_field}", default: (Hash[self.send("#{self.broadcast_channels_text_field}").collect { |item| [item, nil] } ])
				cattr_reader :broadcast_templates_setter_text_field, default: (options[:broadcast_templates_setter_text_field] || :set_broadcast_templates).to_s
				cattr_reader :broadcast_method_text_field, default: (options[:broadcast_method_text_field] || :broadcast).to_s

				self.class_eval do
					attr_accessor self.broadcast_channels_text_field.to_sym
					attr_accessor self.broadcast_templates_text_field.to_sym

					def initialize(attributes)
						instance_variable_set("@#{self.broadcast_channels_text_field}", self.class.send("#{self.broadcast_channels_text_field}"))
						instance_variable_set("@#{self.broadcast_templates_text_field}", self.class.send("#{self.broadcast_templates_text_field}"))
						super
					end 
				end

			end
		end
	end
end