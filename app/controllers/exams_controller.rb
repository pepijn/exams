class ExamsController < ProtectedController
  def index
    if current_user.session
      return redirect_to new_question_answer_path(current_user.session.question_stack.first)
    end

    @exams = Exam.all
  end
end
