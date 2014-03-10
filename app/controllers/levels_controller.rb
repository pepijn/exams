class LevelsController < ApplicationController
  load_and_authorize_resource

  def index
    if qs = current_user.sessions.last.next_question
      redirect_to new_question_answer_path(qs)
    end

    @levels = @levels.includes(:questions)
  end
end

