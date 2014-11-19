module Admin
  class AdminAccessDenied  < StandardError
  end
  
  class AdminController < ApplicationController
    before_filter :authenticate_user!
    before_action :can_access_admin!
    
    protected 
    
    def can_access_admin!
      raise AdminAccessDenied unless admin_access?
    end
    def admin_access?
      user_signed_in? && current_user.admin
    end
  end
end
