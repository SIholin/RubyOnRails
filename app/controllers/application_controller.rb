class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :destroy_session

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def destroy_session
    session[:user_id] = nil
  end
end
