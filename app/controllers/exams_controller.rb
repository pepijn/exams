class ExamsController < ProtectedController
  load_and_authorize_resource

  def index
    if current_user.session
      return redirect_to new_question_answer_path(current_user.session.question_stack.first)
    end

    return redirect_to :courses if @course.nil? if !params[:course_id] && !(last_session = current_user.sessions.last)
    @course = Course.find params[:course_id] || last_session.course_id

    @exams = @course.exams.order('date DESC')
  end

  def show
    redirect_to [:new, @exam, :question]
  end
end

