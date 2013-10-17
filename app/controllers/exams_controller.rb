class ExamsController < ProtectedController
  def index
    if (qs = current_user.question_stack).present?
      return redirect_to new_question_answer_path(qs.first)
    end

    @exams = Exam.all
  end
end
