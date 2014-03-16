class AlertsController < ProtectedController
  def create
    @question = Question.find params[:question_id]
    @alert = @question.alerts.build
    @alert.user = current_user
    @alert.message = params[:alert][:message]
    @alert.save

    redirect_to :back
  end
end

