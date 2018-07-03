require "test_helper"

class ActsAsBroadcasterTest < ActiveSupport::TestCase
	def test_a_users_broadcaster_text_field_should_be_broadcaster
		assert_equal 'broadcaster', User.broadcaster_text_field
	end

	def test_a_institutions_broadcaster_text_field_should_be_custom_name
		assert_equal 'custom_name', Institution.broadcaster_text_field
	end

	def test_a_users_broadcast_channels_text_field_should_be_broadcast_channels
		assert_equal 'broadcast_channels', User.broadcast_channels_text_field
	end

	def test_a_institutions_broadcast_channels_text_field_should_be_custom_name
		assert_equal 'custom_channels', Institution.broadcast_channels_text_field
	end

	def test_a_users_broadcast_channels_should_contain_email_sms_push
		user = User.new
		assert_equal %i{email sms push}, user.broadcast_channels
	end

	def test_a_users_broadcast_channels_should_contain_email
		user = User.new
		user.set_broadcast_channels(%i{email})
		assert_equal %i{email}, user.broadcast_channels
	end

	def test_a_institutions_broadcast_channels_should_contain_email
		institution = Institution.new
		assert_equal %i{email sms push}, institution.custom_channels
	end

	def test_a_users_broadcast_templates_text_field_should_be_broadcast_templates
		user = User.new
		assert_equal 'broadcast_templates', user.broadcast_templates_text_field
	end

	def test_a_institutions_broadcast_templates_text_field_should_be_custom_templates
		assert_equal 'custom_templates', Institution.broadcast_templates_text_field
	end

	def test_a_users_email_broadcast_template_should_be_email_template
		user = User.new
		user.set_broadcast_templates({email: 'email_template'})
		assert_equal 'email_template', user.broadcast_templates[:email]
	end

	def test_a_users_sms_broadcast_template_should_be_sms_string
		user = User.new
		user.set_broadcast_templates({sms: 'sms_string'})
		assert_equal 'sms_string', user.broadcast_templates[:sms]
	end

	def test_a_users_broadcast_templates_should_be_email_template_and_sms_string
		user = User.new
		user.set_broadcast_templates({email: 'email_template', sms: 'sms_string'})
		assert_equal 'email_template', user.broadcast_templates[:email]
		assert_equal 'sms_string', user.broadcast_templates[:sms]
	end

	def test_a_institutions_email_custom_template_should_be_email_template
		institution = Institution.new
		institution.set_custom_templates({email: 'email_template'})
		assert_equal 'email_template', institution.custom_templates[:email]
	end

	def test_a_institutions_sms_custom_template_should_be_sms_string
		institution = Institution.new
		institution.set_custom_templates({sms: 'sms_string'})
		assert_equal 'sms_string', institution.custom_templates[:sms]
	end

	def test_a_institutions_custom_templates_should_be_email_template_and_sms_string
		institution = Institution.new
		institution.set_custom_templates({email: 'email_template', sms: 'sms_string'})
		assert_equal 'email_template', institution.custom_templates[:email]
		assert_equal 'sms_string', institution.custom_templates[:sms]
	end

	# def test_users_broadcast_should_send_notification_via_email
	# 	user = User.new({name: 'Atef Haque'})
	# 	mail = ActionMailer::Base.deliveries.last
	# 	assert_equal 'mikel@test.lindsaar.net', mail['from'].to_s
	# 	assert_equal 'you@test.lindsaar.net', mail['to'].to_s
	# end

	# def test_users_broadcast_should_send_notification_via_sms
	# 	user = User.new({name: 'Atef Haque'})
	# end
end