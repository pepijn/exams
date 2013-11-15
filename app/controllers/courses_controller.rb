class CoursesController < ProtectedController
  load_and_authorize_resource

  def index
    @courses = @courses.order('id DESC')
  end
end

