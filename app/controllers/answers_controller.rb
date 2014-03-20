class AnswersController < ProtectedController
  def new
    @question = Question.where(id: params[:question_id]).first
    @answer = @question.answers.build
    @session = current_user.sessions.last
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.session = current_user.sessions.last
    @question = @answer.question
    @answer.save!
    render :edit
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.correct = answer_params[:correct] === "true"
    @answer.save!

    unless @answer.session.next_question
      # FIXME
      return redirect_to "/sessions/#{@answer.session.id}"
    end

    redirect_to_question
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :input, :correct)
  end
end
