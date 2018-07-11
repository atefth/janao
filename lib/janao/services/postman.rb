require_relative 'postman/base'
require_relative 'postman/mailgun_postman'

module Janao
  module Postman
    
    EMAIL_ADAPTERS = {
        'MailGun' => MailgunPostman
    }
    
    extend self
    
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
    mattr_accessor :adapter, default: 'MailGun'
    
    # Should postman send sms as well?
    mattr_accessor :send_sms, default: true
    
    # Sms length should be
    mattr_accessor :sms_length, default: 160
    
    # Adapter related configurations to be set, Default: ActiveSupport::OrderedOptions.new
    mattr_accessor :mailer_configuration, default: ActiveSupport::OrderedOptions.new
    
    # Configuration for SMS Configuration
    mattr_accessor :sms_configuration, default: ActiveSupport::OrderedOptions.new
    
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
    
    def config
      # Janao::Postman.config do |config|
      #   Use only to send email?
      #   config.send_email                   = true
      #   config.send_sms                     = true
      #   config.adapter                      = 'MailGun'
      #   # Optional parameters
      #   config.mailer_configuration.key     = 'Some sort of identification key'
      #   config.mailer_configuration.secret  = 'Don\'t disclose your secret'
      #   config.sms_configuration.username   = 'iirfann'
      #   config.sms_configuration.password   = 'Passw0rd'
      #   config.common_header                = "<h2>Hay Man</h2>"
      #   config.copyright_message            = "Copyright at Your Company @ 2018"
      # end
      
      yield self
    end
    
    def call(*args)
      options = args.extract_options!
      
      adapter_klass = EMAIL_ADAPTERS.fetch(
          adapter,
          (raise AdapterNotValid, 'please provide a valid adapter, Example: Mailgun, ActionMailer')
      ) # Example: MailgunPostman
      
      name       = options.fetch(:name, (raise EmailTemplateNameNotProvided, 'please provide an email template'))
      send_sms   = options.fetch(:send_sms, Janao::Postman.send_sms) || false
      send_email = options.fetch(:send_email, Janao::Postman.send_email) || false
      
      raise SmsOrEmailShouldBeSwitchedOn, 'please switch on at least on medium (email or sms or both)' unless send_email && send_sms
      
      adapter_klass.(name, *options) if send_email
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