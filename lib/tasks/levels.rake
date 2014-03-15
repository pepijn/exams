task levels: :environment do
  @questions = Question.all
  search = RSemantic::Search.new(@questions.map { |q| [q.text, q.answer].join "\n" }, verbose: false, locale: :nl)

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

  `R < #{Rails.root.join *%w(lib level_creator.R)} --slave`
end

task import: :environment do
  @questions = Question.all

  file = open('/tmp/exams_levels.csv').read
  rows = CSV.parse(file, headers: true)

  rows.each do |row|
    @level = Level.where(id: row['tree']).first || Level.create
    @questions.find(row['id']).update_attributes(level: @level)
  end
end

