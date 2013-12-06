class SessionsController < ProtectedController
  def create
    @exam = Exam.find params[:exam_id]
    session[:questions] = @exam.questions.pluck(:id)

    redirect_to root_url
  end

  def destroy
    session[:questions] = nil

    redirect_to root_url
  end
end
