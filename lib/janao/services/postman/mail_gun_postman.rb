module Janao
  module Postman
    class MailGunPostman < Base
      def self.call(name, *options)
        data = options.extract_options!
        
        new(name, data).() do |mailer|
        
        end
      end
    end
  end
end