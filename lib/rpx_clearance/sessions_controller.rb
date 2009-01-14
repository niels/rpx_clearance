module RpxClearance
  module SessionsController
    
    def self.included(base)
      base.class_eval do
        
        include Clearance::App::Controllers::SessionsController
        include InstanceMethods
        
      end
    end
    
    
    module InstanceMethods
      
      def create
        # Calls Clearance to handle normal (e.g. non-RPX) login
        if params[:session] and !params[:session][:email].blank? and !params[:session][:password].blank?
          super
        else
          if (params[:token] && profile = RpxClearance::Gateway.authenticate(params[:token]))
            unless (user = RpxClearance.user_model.find_by_identifier(profile["identifier"]))
              user = RpxClearance.user_model.create_from_rpx(profile)
            end
            
            log_user_in(user)
            login_successful
          else
            deny_access("Sorry, we couldn't log you in.")
          end
        end
      end
      
    end
    
  end
end