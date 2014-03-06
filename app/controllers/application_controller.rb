class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :detect_ajax
  layout :global_layout
  
  private
    def detect_ajax
      @ajax = request.xhr? || request.GET.has_key?(:ajax)
    end
    def global_layout
      @ajax ? "ajax" : "application"
    end
end
