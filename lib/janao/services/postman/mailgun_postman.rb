module Janao
  module Postman
    class MailgunPostman < Base
      def self.call(name, *options)
        data = options.extract_options!
        
        new(name, data).() do |mailer|
        
        end
      end
    end
  end
end