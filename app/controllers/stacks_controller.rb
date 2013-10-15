class StacksController < ApplicationController
  def create
    @exam = Exam.find params[:exam_id]
    current_user.update question_stack: @exam.questions.pluck(:id)#.shuffle
    redirect_to root_url
  end
end
