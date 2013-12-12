class SessionsController < ProtectedController
  def create
    if params[:exam_id]
      @exam = Exam.find params[:exam_id]
      @questions = @exam.questions
    else
      @questions = current_user.hard_questions(@course)
    end

    session[:questions] = @questions.pluck(:id)

    redirect_to root_url
  end

  def destroy
    session[:questions] = nil

    redirect_to root_url
  end
end
