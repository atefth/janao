require_relative 'postman/base'
require_relative 'postman/mailgun_postman'

module Janao
  module Postman
    
    ADAPTER_MAPPINGS = {
        'MailGun' => MailgunPostman
    }
    
    extend self
    
    # Errors to be used
    EmailNotValid                = Class.new(StandardError)
    AdapterNotValid              = Class.new(StandardError)
    ToEmailNotProvided           = Class.new(ArgumentError)
    AdapterNotSpecified          = Class.new(StandardError)
    PostmanMethodNotImplemented  = Class.new(NotImplementedError)
    EmailTemplateNameNotProvided = Class.new(StandardError)

    # Adapter to be set!
    mattr_accessor :adapter, default: 'MailGun'
    
    # Adapter related configurations to be set, Default: ActiveSupport::OrderedOptions.new
    mattr_accessor :adapter_configuration, default: ActiveSupport::OrderedOptions.new
    
    # Dynamic token validation for email template, Default: true
    mattr_accessor :validate_template_token, default: true
    
    mattr_accessor :common_footer, default: nil
    
    mattr_accessor :common_header, default: nil
    
    # Dynamically convert date format
    mattr_accessor :date_format, default: '%d-%m-%Y'
    
    mattr_accessor :signature, default: nil
    
    mattr_accessor :copyright_message, default: nil
    
    mattr_accessor :company_title, default: nil
    
    def config
      # Janao::Postman.config do |config|
      #   config.adapter                      = 'MailGun'
      #   # Optional parameters
      #   config.adapter_configuration.key    = 'Some sort of identification key'
      #   config.adapter_configuration.secret = 'Don\'t disclose your secret'
      #   config.common_header                = "<h2>Hay Man</h2>"
      #   config.copyright_message            = "Copyright at Your Company @ 2018"
      # end
      
      yield self
    end
    
    def call(*args)
      adapter_klass = ADAPTER_MAPPINGS.fetch(
          adapter,
          ( raise AdapterNotValid, 'please provide a valid adapter, Example: Mailgun, ActionMailer' )
      ) # Example: MailgunPostman
      
      options       = args.extract_options!
      name          = options.fetch(:name, (raise EmailTemplateNameNotProvided, 'please provide an email template'))
      
      adapter_klass.(name, *options)
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