class SessionsController < ProtectedController
  def create
    @session = current_user.sessions.build

    @exam = Exam.find params[:exam_id]
    @session.course = @exam.course
    @session.question_stack = @exam.questions.pluck(:id).shuffle
    @session.save!

    redirect_to root_url
  end

  def destroy
    @session = current_user.session
    @session.question_stack = []
    @session.save!

    redirect_to root_url
  end
end
