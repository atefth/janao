module Janao
	class BroadcasterBuilder
		attr_reader :model
		def initialize(model)
			@model = model
		end

		def self.build(name, model, *args)
			builder = BroadcasterBuilder.new(model)

			case name
			when :set_templates
				builder.set_templates(*args)
			when :set_channels
				builder.set_channels(*args)
			when :broadcast
				builder.broadcast(*args)
			else
				
			end
		end

		def set_templates(*args)
			_args = args.extract_options!
			_args.each_pair do |channel, template|
				model.send("#{model.broadcast_templates_text_field}")[channel] = template
			end
		end

		def set_channels(args)
			model.send("#{model.broadcast_channels_text_field}=", args)
		end

		def broadcast(*args)
			p 'test'
		end

	end
end