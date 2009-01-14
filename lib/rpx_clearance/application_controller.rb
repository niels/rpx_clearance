module RpxClearance
  module ApplicationController
    
    def self.included(base)
      base.class_eval do
        
        include Clearance::App::Controllers::ApplicationController
        
      protected
        include ProtectedMethods
        
      end
    end
    
    
    module ProtectedMethods
      
      # Clearance uses this method
      def user_model
        RpxClearance.user_model
      end
      
    end
    
  end
end