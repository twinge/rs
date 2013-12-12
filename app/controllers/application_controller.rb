class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def self.application_name
    'RS'
  end

  def current_event
    session[:conference_id] = params[:conference_id] if params[:conference_id]

    @current_event ||= Event.where(:conference_id => session[:conference_id]).first if session[:conference_id]
  end
end
