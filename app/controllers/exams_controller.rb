class ExamsController < ProtectedController
  load_and_authorize_resource

  def index
    if session[:questions].present?
      return redirect_to new_question_answer_path(session[:questions].first)
    end

    @course = Course.find params[:course_id] || Answer.last.course

    @exams = @course.exams.order('date DESC')
  end

  def show
    redirect_to [:new, @exam, :question]
  end
end

