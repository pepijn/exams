class Exam < ActiveRecord::Base
  belongs_to :course
  has_many :questions

  validates :date, presence: true
  validates :course, presence: true

  def to_s
    name
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

