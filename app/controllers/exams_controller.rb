class ExamsController < ProtectedController
  load_and_authorize_resource

  def index

  end

  def update
    @exam = Exam.find params[:id]
    exam_params[:questions_attributes].map { |_,q| q[:text].strip!; q[:answer].strip! }
    @exam.update exam_params

    redirect_to @exam
  end

  private

  def exam_params
    params.require(:exam).permit(questions_attributes: [:id, :number, :text, :answer])
  end
end

