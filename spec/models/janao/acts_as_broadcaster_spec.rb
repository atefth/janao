require 'rails_helper'

RSpec.describe Janao::ActsAsBroadcaster, type: :model do
	describe "the acts_as_broadcaster instance method" do
		describe "contains default class attributes" do
			describe "named broadcast_channels_text_field" do
				context "when broadcast_channels_text_field is not set" do
					it "defaults to broadcast_channels" do
						expect(User.broadcast_channels_text_field).to eq('broadcast_channels')
					end
				end
				context "when broadcast_channels_text_field is set" do
					it "can be customized for models" do
						expect(User.broadcast_channels_text_field).to eq('broadcast_channels')
						expect(Institution.broadcast_channels_text_field).to eq('custom_channels')
					end
				end
			end
			describe "generated from text_fields" do
				context "when using broadcast_channels_text_field" do
					it "defaults to broadcast_channels" do
						user = User.new
						expect(user.broadcast_channels).not_to be_nil
					end
					it "can be customized for models" do
						institution = Institution.new
						expect {institution.broadcast_channels}.to raise_error(NoMethodError)
						expect(institution.custom_channels).not_to be_nil
					end
					it "contains a default list of channels" do
						user = User.new
						expect(user.broadcast_channels).to eq(%i{email sms push})

						institution = Institution.new
						expect(institution.custom_channels).to eq(%i{email sms push})
					end
				end
				context "when using broadcast_channels_setter_text_field" do
					it "defaults to set_broadcast_channels" do
						user = User.new
						expect(user.respond_to?(:set_broadcast_channels)).to be_truthy
					end
					it "can be customized for models" do
						institution = Institution.new
						expect {institution.set_broadcast_channels}.to raise_error(NoMethodError)
						expect(institution.respond_to?(:set_custom_channels)).to be_truthy
					end
					it "can be used set customized channels" do
						user = User.new
						user.set_broadcast_channels(%i{email})
						expect(user.broadcast_channels).to eq(%i{email})

						institution = Institution.new
						institution.set_custom_channels(%i{email sms})
						expect(institution.custom_channels).to eq(%i{email sms})
					end
				end
				context "when using broadcast_templates_text_field" do
					it "defaults to broadcast_templates" do
						user = User.new
						expect(user.broadcast_templates).not_to be_nil
					end
					it "can be customized for models" do
						institution = Institution.new
						expect {institution.broadcast_templates}.to raise_error(NoMethodError)
						expect(institution.custom_templates).not_to be_nil
					end
					it "contains a default list of templates" do
						user = User.new
						expect(user.broadcast_templates).to eq({email: nil, sms: nil, push: nil})
					end
				end
				context "when using broadcast_templates_setter_text_field" do
					it "defaults to set_broadcast_templates" do
						user = User.new
						expect(user.respond_to?(:set_broadcast_templates)).to be_truthy
					end
					it "can be customized for models" do
						institution = Institution.new
						expect {institution.set_broadcast_templates}.to raise_error(NoMethodError)
						expect(institution.respond_to?(:set_custom_templates)).to be_truthy
					end
					it "can be used set customized templates" do
						user = User.new
						user.set_broadcast_templates({email: 'email_string'})
						expect(user.broadcast_templates[:email]).to eq('email_string')

						institution = Institution.new
						institution.set_custom_templates({sms: 'sms_string'})
						expect(institution.custom_templates[:sms]).to eq('sms_string')
					end
				end
			end
		end
	end
end
