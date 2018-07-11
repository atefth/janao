module Janao
  module Postman
    class Base
      attr_reader :name, :to_emails, :from_emails, :cc_emails, :bcc_emails, :template, :data
      
      def initialize(name, *args)
        options      = args.extract_options!
        @name        = name
        @to_emails   = options.fetch(:to)
        @from_emails = options.fetch(:from)
        @cc_emails   = options.fetch(:cc)
        @bcc_emails  = options.fetch(:bcc)
        @template    = options.fetch(:template)
        @data        = options.fetch(:data)
        
        validate_emails_presence(@to_emails)
        
        yield self if block_given?
        
        self
      end
      
      # This has to be used through block for
      # every new mailer. Check MailgunPostman for
      # implementation example
      def deliver
        raise PostmanMethodNotImplemented, "#{__method__} must be implemented to use this service"
        
        yield(self) if block_given?
        
        self
      end
      
      private
      
      def validate_emails_presence(emails)
        raise ToEmailNotProvided, "please provide email(s) to send email" if emails.compact.blank?
      end
    end
  end
end