class Session < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  belongs_to :course

  validates :course, presence: true

  def question
    Question.find question_stack.first
  end

  def finished
    answers.count
  end

  def remaining
    question_stack.length
  end

  def count
    finished + remaining
  end

  def completion
    1 - (remaining.to_f / count)
  end
end

