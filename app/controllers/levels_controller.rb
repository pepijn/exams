class LevelsController < ApplicationController
  def index

    if current_user && (ls = current_user.sessions.last) && (qs = ls.next_question)
      redirect_to new_question_answer_path(qs)
    end

    @levels = Level.includes(:questions).order('number ASC')
  end

  def show
    @level = Level.find params[:id]
  end
end

