module Janao
  module Postman
    class CustomSmsGateway
      
      attr_reader :numbers, :sms_data, :params, :template_name,
                  :template, :template_name, :sms_text, :url,
                  :port, :http_method, :uri, :host, :path,
                  :constant_params
      
      def initialize(template_name, numbers, sms_data = {}, params = {})
        @numbers         = Array.wrap(numbers)
        @sms_data        = sms_data
        @params          = params
        @template_name   = template_name
        @template        = find_template
        @sms_text        = compose_sms_text
        @host            = Postman::Janao.sms_configuration.host
        @path            = Postman::Janao.sms_configuration.path
        @port            = Postman::Janao.sms_configuration.port
        @http_method     = Postman::Janao.sms_configuration.http_method.upcase.to_sym
        @constant_params = Postman::Janao.sms_configuration.params
        @uri             = URI(url)
      end
      
      def call
        numbers.each do |number|
          send_sms(number)
        end
      end
      
      def self.call(template_name, numbers, sms_data = {}, params = {})
        new(template_name, sms_data, numbers, params).()
      end
      
      private
      
      def compose_sms_text
      
      end
      
      def find_template
      
      end
      
      def build_url
        params = {}
        params.merge!(Postman::Janao.sms_configuration.options)
        params.merge!(params)
        
        case http_method
          when :GET
          
          when :POST, :PUT
        
        end
      end
      
      def send_sms(number)
      
      end
    end
  end
end