class AnswersController < ProtectedController
  before_filter do
    @last_answer = Answer.last
  end

  def new
    return redirect_to exams_path unless current_session

    @question = Question.find params[:question_id]
    @options = @question.options.shuffle
    @exam = @question.exam
    @last_answer = current_user.session.answers.last || Answer.new
    @options << Option.new(text: 'Weet ik niet') if @last_answer && @last_answer.option.present?
    @answer = @question.answers.build
  end

  def create
    @answer = current_session.answers.create! answer_params

    session = current_user.sessions.last

    if @answer.correct?
      session.question_stack = session.question_stack[1..-1]
    elsif !session.question_stack[1..-1].include? @answer.question.id
      session.question_stack.insert rand(2..4), @answer.question.id
    end

    session.question_stack_will_change!
    session.save!
    redirect_to new_question_answer_path(session.question_stack.first)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :option_id)
  end
end
