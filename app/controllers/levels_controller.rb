class LevelsController < ProtectedController
  load_and_authorize_resource

  def index

    if (ls = current_user.sessions.last) && (qs = ls.next_question)
      redirect_to new_question_answer_path(qs)
    end

    @levels = @levels.includes(:questions)
  end
end

