class SessionsController < ProtectedController
  def show
    @session = current_user.sessions.find params[:id]
  end

  def create
    @level = Level.find params[:level_id]
    current_user.sessions.create level: @level

    return redirect_to root_url
  end

  def destroy
    @session = current_user.sessions.last
    @session.destroy

    redirect_to @session.level
  end
end
