class AnswersController < ProtectedController
  before_filter do
    @last_answer = Answer.last
  end

  def new
    return redirect_to exams_path if current_user.question_stack.empty?

    @question = Question.find current_user.question_stack.shift
    @options = @question.options.shuffle
    @exam = @question.exam
    @last_answer = current_user.answers.last || Answer.new
    @options << Option.new(text: 'Weet ik niet') if @last_answer && @last_answer.option.present?
    @answer = @question.answers.build
  end

  def create
    @answer = current_user.answers.create! answer_params

    redirect_to new_question_answer_path(current_user.question_stack.first)

    return unless @answer.option

    if @answer.correct?
      current_user.question_stack = current_user.question_stack[1..-1]
    else
      return if current_user.question_stack.include? @answer.question.id
      current_user.question_stack.insert rand(2..4), @answer.question.id
    end

    current_user.question_stack_will_change!
    current_user.save!
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :option_id)
  end
end
