class SessionsController < ProtectedController
  def create
    @session = current_user.sessions.build

    case params[:exam_id]
    when 'hard_questions'
      @session.question_stack = current_user.hard_questions.map &:id
    else
      exam = Exam.find params[:exam_id]
      @session.question_stack = exam.questions.pluck(:id).shuffle
    end

    @session.save!

    redirect_to root_url
  end
end
