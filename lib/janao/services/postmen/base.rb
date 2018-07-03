module Janao
  module Postmen
    class Base
      attr_reader :to_emails, :from_emails, :cc_emails, :bcc_emails, :template, :data
      
      def initialize(*args)
        options = args.extract_options!
        
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
      
      def deliver
        raise PostmanMethodNotImplemented, "#{__method__} must be implemented to use this service"
        
        yield self if block_given?
        
        self
      end
      
      def validate_emails_presence(emails)
        raise ToEmailNotProvided, "please provide email(s) to send email" if emails.compact.blank?
      end
    end
  end
end