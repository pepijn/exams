class AnswersController < ProtectedController
  before_filter do
    @last_answer = Answer.last
  end

  def new
    return redirect_to exams_path if current_user.question_stack.empty?

    @question = Question.find current_user.question_stack.shift
    @options = @question.options + [Option.new(text: 'Weet ik niet')]
    @exam = @question.exam
    @answer = Answer.last
  end

  def create
    redirect_to new_question_answer_path(current_user.question_stack.first)
    return if answer_params[:option_id].to_i.zero?

    @answer = Answer.create! answer_params

    if @answer.correct?
      current_user.question_stack = current_user.question_stack[1..-1]
    else
      current_user.question_stack.insert rand(2..4), @answer.question.id
    end

    current_user.question_stack_will_change!
    current_user.save!

  end

  private

  def answer_params
    params.require(:answer).permit(:option_id)
  end
end
