class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :destroy_session
  helper_method :ensure_that_signed_in

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def destroy_session
    session[:user_id] = nil
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be singed in' if current_user.nil?
  end
end
