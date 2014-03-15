class AlertsController < ProtectedController
  def create
    @question = Question.find params[:question_id]
    @alert = @question.alerts.create user: current_user
    redirect_to :back
  end
end
