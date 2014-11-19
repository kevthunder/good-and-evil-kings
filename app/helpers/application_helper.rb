module ApplicationHelper
    def admin_access?
      user_signed_in? && current_user.admin
    end
end
