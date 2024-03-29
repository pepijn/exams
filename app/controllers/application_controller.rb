class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  layout lambda { |c| c.request.xhr? ? false : "application" }

  protected

  def redirect_to_question
    if current_user && (ls = current_user.sessions.last) && (nq = ls.next_question)
      redirect_to new_question_answer_path(nq)
    end
  end

  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :student_number, :coupon) }
    #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end

