class LevelsController < ApplicationController

  def index
    redirect_to_question

    @levels = Level.includes(:questions).order('number ASC')
  end

  def show
    @level = Level.find params[:id]
  end
end

