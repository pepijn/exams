# encoding: utf-8

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
  Question.update_all(level_id: nil)

  rows.each do |row|
    @level = Level.where(number: row['level']).first || Level.create(number: row['level'])
    @questions.find(row['id']).update_column(:level_id, @level.id)
  end

  #Level.all.sort_by { |l| l.questions.count }.each.with_index do |level, index|
  Level.all.reverse.each.with_index do |level, index|
    level.update_column(:number, index + 1)
  end
end

task levels: :environment do
  `R < #{Rails.root.join *%w(lib level_creator.R)} --slave`

  Rake::Task["import"].execute
end

task export: :environment do
  Question.all.each do |question|
    File.open("/tmp/questions/#{question.id}", "w") do |f|
      f.write question.text
      f.write "\n"
      f.write question.answer
      f.write "\n\r"
      f.close
    end
  end
end

