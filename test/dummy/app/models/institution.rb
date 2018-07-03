class Institution < ApplicationRecord
	acts_as_broadcaster broadcaster_text_field: :custom_name, broadcast_channels_text_field: :custom_channels, broadcast_channels_setter_text_field: :set_custom_channels, broadcast_templates_text_field: :custom_templates, broadcast_templates_setter_text_field: :set_custom_templates, broadcast_method_text_field: :custom_push
end
