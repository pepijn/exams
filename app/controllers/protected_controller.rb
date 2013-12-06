class ProtectedController < ApplicationController
  before_filter do
    return redirect_to new_user_session_url unless user_signed_in?
    authenticate_user!

    # Make nil if session empty
    session[:questions] ||= []
    session[:questions].compact!

    # Current course
    @course = current_user.answers.last.try :course
  end
end

