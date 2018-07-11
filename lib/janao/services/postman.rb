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
    
    # For configuration object
    Configuration = Class.new(ActiveSupport::OrderedOptions)
    
    # Errors to be used
    EmailNotValid                = Class.new(StandardError)
    AdapterNotValid              = Class.new(StandardError)
    ToEmailNotProvided           = Class.new(ArgumentError)
    AdapterNotSpecified          = Class.new(StandardError)
    PostmanMethodNotImplemented  = Class.new(NotImplementedError)
    SmsOrEmailShouldBeSwitchedOn = Class.new(StandardError)
    EmailTemplateNameNotProvided = Class.new(StandardError)
    
    mattr_accessor :send_email, default: true
    
    # Adapter to be set!
    mattr_accessor :email_adapter, default: 'MailGun'
    
    mattr_accessor :sms_adapter, default: 'Custom'
    
    # Should postman send sms as well?
    mattr_accessor :send_sms, default: true
    
    # Sms length should be
    mattr_accessor :sms_length, default: 160
    
    # Adapter related configurations to be set, Default: Configuration.new
    mattr_accessor :mailer_configuration, default: Configuration.new
    
    # Configuration for SMS Configuration
    mattr_accessor :sms_configuration, default: Configuration.new
    
    # Dynamic token validation for email template, Default: true
    mattr_accessor :validate_template_token, default: true
    
    # Template related settings
    mattr_accessor :common_footer, default: nil
    
    mattr_accessor :common_header, default: nil
    
    # Dynamically convert date format
    mattr_accessor :date_format, default: '%d-%m-%Y'
    
    mattr_accessor :signature, default: nil
    
    mattr_accessor :copyright_message, default: nil
    
    mattr_accessor :company_title, default: nil
    
    # Config Janao::Postman to send email and sms notifications
    # Alias method is .setup of .config, you can use both
    #
    # Example:
    #   Janao::Postman.setup do |config|
    #     # Use only to send email?
    #     config.send_email                   = true
    #     config.send_sms                     = true
    #     config.email_adapter                = 'MailGun'
    #     config.sms_adapter                  = 'Custom'
    #     # Optional parameters
    #     config.mailer_configuration.key     = 'Some sort of identification key'
    #     config.mailer_configuration.secret  = 'Don\'t disclose your secret'
    #     config.sms_configuration.username   = 'iirfann'
    #     config.sms_configuration.password   = 'Passw0rd'
    #     config.common_header                = "<h2>Hay Man</h2>"
    #     config.copyright_message            = "Copyright at Your Company @ 2018"
    #   end
    
    def config
      yield self
    end
    
    alias_method :setup, :config
    
    # Just use .() to Send notifications!
    # .()
    #
    # @param[Hash] emails to send emails
    # @param[Array] emails[:to] collection of emails to be used in to
    # @param[Array] emails[:cc] collection of emails to be used in cc
    # @param[Array] emails[:bcc] collection of emails to be used in bcc
    # @param[String] email_template_name to determine the template of email
    # @param[Hash] sms_data to send sms
    # @param[Array] numbers to be sent in sms
    # @param[String] sms_template_name to determine the sms template
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