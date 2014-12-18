class AccessDenied  < StandardError
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :fire_updater
  before_action :detect_ajax
  before_action :home_redir_for_anonymous
  layout :global_layout
  
  
  helper_method :garrisons_path_for
  def garrisons_path_for(garrisonable)
    return garrisons_for_path(garrisonable.garrisonable_type.underscore.pluralize,garrisonable.garrisonable_id) if garrisonable.class.model_name == Garrison.model_name
    garrisons_for_path(garrisonable.class.model_name.to_s.pluralize,garrisonable.id)
  end
  
  helper_method :current_castle_path
  def current_castle_path()
    return castle_path(current_user.current_castle)
  end
  
  private
    def home_redir_for_anonymous
      redirect_to preview_path if request.fullpath == root_path && !user_signed_in?
    end
    def detect_ajax
      @ajax = request.xhr? || request.GET.has_key?(:ajax)
    end
    def global_layout
      @ajax ? "ajax" : (user_signed_in? ? "application" : "preview")
    end
    def fire_updater
      Updater.update if Updater.before_every_actions
    end
    def set_my_castles
      @myCastles = current_user.castles unless current_user.nil?
    end
end
