class AnswersController < ProtectedController
  def new
    @question = Question.where(id: params[:question_id]).first
    @answer = @question.answers.build
  end

  def create
    @answer = Answer.new(answer_params)
    @question = @answer.question
    @answer.save!
    render :edit
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.correct = answer_params[:correct] === "true"
    @answer.save!
    redirect_to new_answer_path(question_id: @answer.level.questions.sample)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :input, :correct)
  end
end
