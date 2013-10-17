class ProtectedController < ApplicationController
  before_filter do
    return redirect_to new_user_session_url unless user_signed_in?
    authenticate_user!
  end
end

