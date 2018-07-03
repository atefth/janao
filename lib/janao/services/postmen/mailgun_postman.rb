module Janao
  module Postmen
    class MailgunPostman < Base
      def deliver
      
      end
      
      def self.deliver(*args)
        new(*args) do |_adapter_|
          _adapter_.deliver
        end
      end
    end
  end
end