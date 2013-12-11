class QuestionsController < ProtectedController
  authorize_resource

  def index
    @course = Course.find params[:course_id] if params[:course_id]

    @answers = @course.answers.where(user: current_user)

    @score = {}
    @answers.each do |answer|
      @score[answer.question_id] ||= 0
      @score[answer.question_id] += answer.correct? ? 1 : -1
      @score[answer.question_id]
    end

    @questions = Question.where(id: @answers.map(&:question_id))
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

  private

  def question_params
    params.require(:question).permit(:exam_id, :number, :text, :attachment, options_attributes: [:text])
  end
end

