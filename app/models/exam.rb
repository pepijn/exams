class Exam < ActiveRecord::Base
  belongs_to :course
  has_many :questions, dependent: :destroy

  validates :date, presence: true
  validates :course, presence: true
  validates :source, presence: true

  accepts_nested_attributes_for :questions, update_only: true

  default_scope -> { order('date DESC') }

  has_attached_file :source

  after_save do
    segments.each do |number, text|
      question = questions.build number: number, text: text

      split = question.text.split(/^Antwoord[:]?/)

      if split.length === 2
        question.text = split.first.strip
        question.answer = split.last.strip
      end

      question.save
    end
  end

  def to_s
    name
  end

  def segments
    body = `pdftotext -raw -enc UTF-8 -nopgbrk #{source.path} -`
    body.gsub!(/^(BLOK(.*)|\d+-\d+-\d+|\s+\d+$|Naam student.+|\d+$)/, '')

    segments = body.split /^Vraag (\d+).*$/
    segments.shift
    segments.map &:strip!

    Hash[*segments]
  end

  def name
    date.to_s
  end

  def question_count
    questions.count
  end

  rails_admin do
    list do
      field :course
      field :date
      field :question_count
    end

    edit do
      exclude_fields :questions
    end
  end
end

