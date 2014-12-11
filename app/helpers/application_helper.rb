module ApplicationHelper
    def admin_access?
      user_signed_in? && current_user.admin
    end
    
    def nav_link(link_text, link_path)
      class_name = current_page_with_root_alias?(link_path) ? 'current' : ''

      content_tag(:li, :class => class_name) do
        link_to link_text, link_path
      end
    end
    
    def model_action_class
      params[:controller].parameterize + '-' + params[:action]
    end
    
    def current_page_with_root_alias?(url)
      current_page?(url) ||
      (
        current_page?(root_path) &&
        Rails.application.routes.recognize_path("/") == Rails.application.routes.recognize_path(url)
      )
    end
end
