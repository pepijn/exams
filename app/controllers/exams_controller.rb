class ExamsController < ProtectedController
  load_and_authorize_resource

  def index

  end

  def update
    @exam = Exam.find params[:id]
    @exam.update_attributes!(exam_params)
    render :show
  end

  private

  def exam_params
    params.require(:exam).permit(questions_attributes: [:id, :text, :answer])
  end
end

