class QuestionsController < ApplicationController
  load_and_authorize_resource except: :index

  def index
    authenticate_user!

    @questions = Hash.new(0)
    current_user.answers.where.not(correct: true).each do |answer|
      @questions[answer.question_id] += 1
    end

    @questions = @questions.sort_by { |_, v| v }.reverse[0..50]
    @questions = @questions.map { |k,_| Question.find k }
  end

  def show
    redirect_to new_question_answer_path(params[:id])
  end

  def new
    @exam = Exam.find params[:exam_id]
    @last_question = @exam.questions.last || Question.new
    @question = @exam.questions.build
  end

  def create
    params = question_params
    params[:options_attributes].delete_if { |o| o[:text].empty? }

    @question = Question.create! params

    redirect_to [:new, @question.exam, :question]
  end

  def destroy
    @question.destroy
    redirect_to :back
  end

  private

  def question_params
    params.require(:question).permit(:exam_id, :number, :text, :attachment, options_attributes: [:text])
  end
end

