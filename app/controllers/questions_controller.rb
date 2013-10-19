class QuestionsController < ProtectedController
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
    params.require(:question).permit(:exam_id, :number, :text, options_attributes: [:text])
  end
end
