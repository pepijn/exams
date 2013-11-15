class Exam < ActiveRecord::Base
  belongs_to :course
  has_many :questions

  def name
    date
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
  end
end

