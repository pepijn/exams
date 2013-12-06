class AnswersController < ProtectedController
  def new
    return redirect_to exams_path unless session[:questions]

    @question = Question.where(id: params[:question_id]).first

    @options = @question.options.shuffle
    @exam = @question.exam
    @course = @exam.course
    @last_answer = Answer.find(flash[:last_answer_id]) if flash[:last_answer_id]
    @options << Option.new(text: 'Weet ik niet')
    @answer = @question.answers.build
  end

  def create
    if current_user.credits_remaining?
      flash[:alert] = "Je hebt niet genoeg credits"
      return redirect_to :back
    end

    @answer = current_user.answers.build answer_params
    @answer.input = nil if @answer.input && @answer.input.empty?
    @answer.save!
    flash[:last_answer_id] = @answer.id

    if @answer.correct?
      session[:questions].shift
    else
      session[:questions].insert rand(8..12), @answer.question_id
    end

    return redirect_to :root if session[:questions].empty?
    redirect_to new_question_answer_path(session[:questions].first)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :option_id, :input)
  end
end
