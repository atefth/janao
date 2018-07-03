require_relative 'postmen/base'
require_relative 'postmen/mailgun_postman'

module Janao
  module Postmen
    
    ADAPTER_MAPPINGS = {
        'MailGun' => MailgunPostman
    }
    
    extend self
    
    # Errors to be used
    PostmanMethodNotImplemented = Class.new(NotImplementedError)
    AdapterNotValid             = Class.new(StandardError)
    ToEmailNotProvided          = Class.new(ArgumentError)
    EmailNotValid               = Class.new(StandardError)
    AdapterNotSpecified         = Class.new(StandardError)
    
    # Adapter to be set!
    mattr_accessor :adapter, default: 'MailGun'
    
    def config
      yield self
    end
    
    def deliver(*args)
      @adapter_klass = ADAPTER_MAPPINGS[adapter]
      
      raise AdapterNotValid, 'please provide a valid adapter' unless @adapter_klass

      @adapter_klass.deliver(*args)
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