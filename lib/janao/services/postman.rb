require_relative 'postman/base'
require_relative 'postman/mail_gun_postman'
require_relative 'postman/custom_sms_gateway'

module Janao
  module Postman
    
    EMAIL_ADAPTERS = {
        'MailGun' => MailGunPostman
    }
    
    SMS_ADAPTERS = {
        'Custom' => CustomSmsGateway
    }
    
    extend self
    
    # Sets configuration object for various adapter
    #
    class Configuration < ActiveSupport::OrderedOptions; end
    
    # Error classes to be used
    #
    class EmailNotValid                < StandardError; end # Raise when Email address not valid
    class AdapterNotValid              < StandardError; end # Raise when Adapter not configured from the valid list
    class ToEmailNotProvided           < StandardError; end # Raise when Email address not provided
    class AdapterNotSpecified          < StandardError; end # Raise when Adapter not specified
    class PostmanMethodNotImplemented  < NotImplementedError; end # Raise when expected method not implemented
    class SmsOrEmailShouldBeSwitchedOn < StandardError; end # Raise when both sms and email is disabled from the configuration.
    class EmailTemplateNameNotProvided < StandardError; end
    
    # Sets if engine can also send emails
    mattr_accessor :send_email, default: true
    
    # Sets email adapter to be used, Default: 'MailGun'
    mattr_accessor :email_adapter, default: 'MailGun'
    
    # Sets sms adapter, Default: 'Custom'
    mattr_accessor :sms_adapter, default: 'Custom'
    
    # Sets configuration that allow engine to send sms as well
    mattr_accessor :send_sms, default: true
    
    # Sets sms length to be validated dynamically
    mattr_accessor :sms_length, default: 160
    
    # Sets adapter related configurations to be set, Default: Configuration.new
    mattr_accessor :mailer_configuration, default: Configuration.new
    
    # Sets configuration for SMS
    mattr_accessor :sms_configuration, default: Configuration.new
    
    # Sets dynamic token validation for email template, Default: true
    mattr_accessor :validate_template_token, default: true
    
    # Sets template related settings
    mattr_accessor :common_footer, default: nil
    
    # Sets common_header, default: nil
    mattr_accessor :common_header, default: nil
    
    # Sets date format dynamically
    mattr_accessor :date_format, default: '%d-%m-%Y'
    
    # Sets signature, default: nil
    mattr_accessor :signature, default: nil
    
    # Sets copyright_message, default: nil
    mattr_accessor :copyright_message, default: nil
    
    # Sets company_title, default: nil
    mattr_accessor :company_title, default: nil
    
    # Config Janao::Postman to send email and sms notifications
    # Alias method is .setup of .config, you can use both
    #
    # Example:
    #       Janao::Postman.setup do |config|
    #         # Use only to send email?
    #         config.send_email                   = true
    #         config.send_sms                     = true
    #         config.email_adapter                = 'MailGun'
    #         config.sms_adapter                  = 'Custom'
    #         # Optional parameters
    #         config.mailer_configuration.key     = 'Some sort of identification key'
    #         config.mailer_configuration.secret  = 'Don\'t disclose your secret'
    #         config.sms_configuration.username   = 'iirfann'
    #         config.sms_configuration.password   = 'Passw0rd'
    #         config.common_header                = "<h2>Hay Man</h2>"
    #         config.copyright_message            = "Copyright at Your Company @ 2018"
    #       end
    #
    #
    # @return [Janao::Postman] instance
    def config
      yield self
    end
    
    alias_method :setup, :config
    
    # Just use .() to Send notifications!
    # .()
    #
    # The gateway to send message is to call this method
    #
    #   Janao::Postman.({
    #     email: {
    #       to: ['irfandhk@gmail.com', 'atef@hashkloud.com']
    #     },
    #     email_template_name: 'registration_greetings',
    #     email_data: { full_name: 'Irfan Ahmed', tnx_number: 'HK29874297492842' },
    #     sms_data: { full_name: 'Irfan Ahmed', tnx_number: 'HK29874297492842' },
    #     numbers: ['+8801766678130', '+880197767130'],
    #     sms_template_name: 'greet_new_user'
    #   })
    #
    # @overload method(options)
    #   @param [Array] args
    #   @option options [String] :subject email's subject.
    #   @option options [Hash] :email that takes to, cc and bcc keys witht the value of array type
    #   @option options [String] :email_template_name to load the expected template provided by client
    #   @option options [Hash] :email_data that contains token values of email template
    #   @option options [Boolean] :send_email should be true by configuration
    #   @option options [Boolean] :send_sms should be true or false by configuration
    #   @option options [Hash] :sms_data should contain token values for sms template's token
    #   @option options [Array] :numbers should represents list of numbers sms to be sent
    #   @option options [String] :sms_template_name should represent the sms text template
    #
    # @return [Janao::Postman::Result] object that contains messages, error (true/false), backtrace: []
    def call(*args)
      options = args.extract_options!
      
      send_sms   = options.fetch(:send_sms, Janao::Postman.send_sms) || false
      send_email = options.fetch(:send_email, Janao::Postman.send_email) || false
      
      raise SmsOrEmailShouldBeSwitchedOn, 'please switch on at least on medium (email or sms or both)' unless send_email && send_sms
      
      if send_email
        adapter_klass = EMAIL_ADAPTERS.fetch(
            adapter,
            (raise AdapterNotValid, 'please provide a valid adapter, Example: Mailgun, ActionMailer')
        ) # Example: MailgunPostman
        name          = options.fetch(:name, (raise EmailTemplateNameNotProvided, 'please provide an email template'))
        
        adapter_klass.(name, *options) if send_email
      end
      
      if send_sms
        numbers           = Array.wrap(options.fetch(:numbers))
        sms_template_name = options.fetch(:sms_template_name) || nil
        sms_params        = options.fetch(:sms_params, {})
        sms_adapter_klass = SMS_ADAPTERS[Janao::Postman.sms_adapter]
        
        sms_adapter_klass.(sms_template_name, numbers, options.fetch(:sms_options, {}), sms_params)
      end
    end
  end
end

#
#
# 1. Converted to rails engine
# 2. Extend application record from engine
# 3. Initialize basic postman configuration with base class
#
# Janao::Postmen::Base holds the responsibilities to
# 1. configure basic parameters
# 2. provides common gateway to deliver an email
# 3. use configured email adapter
#
# Postment takes configurations to
# 1. Setup adapter,
# 2. Example: Janao::Postmen.config {|config|  config.adapter = 'AtefMail' }
#
# Janao::Postmen.config do |config|
#   config.adapter = 'AtefMail'
# end
#