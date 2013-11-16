class AnswersController < ProtectedController
  before_filter do
    @last_answer = Answer.last
  end

  def new
    return redirect_to exams_path unless current_session

    @question = Question.where(id: params[:question_id]).first

    unless @question
      session = current_session
      session.question_stack.shift
      session.question_stack_will_change!
      session.save!
      return redirect_to new_question_answer_path(session.question_stack.first)
    end

    @options = @question.options.shuffle
    @exam = @question.exam
    @last_answer = (id = flash[:last_answer_id]) ? Answer.find(id) : Answer.new
    @options << Option.new(text: 'Weet ik niet')
    @answer = @question.answers.build
  end

  def create
    @answer = current_session.answers.build answer_params
    @answer.input = nil if @answer.input && @answer.input.empty?
    @answer.save!
    flash[:last_answer_id] = @answer.id

    session = current_user.sessions.last

    if @answer.correct?
      session.question_stack = session.question_stack[1..-1].compact
    elsif !session.question_stack[1..-1].include? @answer.question.id
      session.question_stack.insert rand(8..12), @answer.question.id
    end

    session.question_stack_will_change!
    session.save!

    return redirect_to :root if session.question_stack.empty?
    redirect_to new_question_answer_path(session.question_stack.first)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :option_id, :input)
  end
end
