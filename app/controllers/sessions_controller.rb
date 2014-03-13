class SessionsController < ProtectedController
  def create
    @level = Level.find params[:level_id]
    current_user.sessions.create level: @level

    return redirect_to root_url
  end

  def destroy
    current_user.sessions.last.destroy

    redirect_to root_url
  end
end
