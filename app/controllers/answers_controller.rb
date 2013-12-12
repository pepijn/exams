class AnswersController < ProtectedController
  def new
    return redirect_to exams_path unless session[:questions]

    @question = Question.where(id: params[:question_id]).first

    @options = @question.options.shuffle
    @exam = @question.exam
    @course = @exam.course
    @options << Option.new(text: 'Weet ik niet')
    @answer = @question.answers.build
  end

  def create
    if current_user.credits_remaining?
      flash[:warning] = "Je hebt niet genoeg credits om deze vraag te beantwoorden"
      return redirect_to new_order_url
    end

    @answer = current_user.answers.build answer_params
    @answer.input = nil if @answer.input && @answer.input.empty?
    @answer.save!

    if @answer.correct?
      session[:questions].shift
      flash[:notice] = render_to_string partial: 'correct'
    elsif @answer.pass?
      session[:questions].insert rand(8..12), @answer.question_id
      session[:questions].shift
      flash[:warning] = render_to_string partial: 'pass'
    else
      flash[:alert] = render_to_string partial: 'incorrect'
    end

    return redirect_to :root if session[:questions].compact.empty?

    @question = Question.find(session[:questions].compact.first)
    redirect_to new_question_answer_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :option_id, :input)
  end
end
