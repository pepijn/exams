class QuestionsController < ProtectedController
  load_and_authorize_resource

  def index
    @questions = Question.all
    search = RSemantic::Search.new(@questions.map(&:text), verbose: false, locale: :nl)

    File.open('/tmp/exams_matrix', 'w') do |out|
      @questions.each do |question|
        out << ",#{question.id}"
      end
      out << "\n"

      @questions.each.with_index do |question, index|
        out << question.id.to_s
        search.related(index).each do |similarity|
          out << ','
          out << 1 - similarity.round(5)
        end
        out << "\n"
      end
    end

    data = `R < #{Rails.root.join *%w(lib level_creator.R)} --slave`
    rows = CSV.parse(data, headers: true)

    rows.each do |row|
      @level = Level.where(id: row['tree']).first || Level.create
      @questions.find(row['id']).update_attributes(level: @level)
    end

    return render text: levels
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

