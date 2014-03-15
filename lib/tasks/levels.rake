task analyse: :environment do
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
end

task import: :environment do
  @questions = Question.all

  data = open('/tmp/exams_levels.csv').read
  rows = CSV.parse(data, headers: true)

  Level.delete_all
  rows.each do |row|
    @level = Level.where(number: row['tree.labels']).first || Level.create(number: row['tree.labels'])
    @questions.find(row['id']).update_column(:level_id, @level.id)
  end
end

task levels: :environment do
  `R < #{Rails.root.join *%w(lib level_creator.R)} --slave`

  Rake::Task["import"].execute
end

