class SessionsController < ProtectedController
  def create
    @level = Level.find params[:level_id]
    current_user.sessions.create level: @level

    return redirect_to root_url
  end

  def destroy
    session[:questions] = nil

    redirect_to root_url
  end
end
