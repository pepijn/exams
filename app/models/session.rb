class Session < ActiveRecord::Base
  belongs_to :level
  belongs_to :user

  has_many :questions, through: :level
  has_many :answers

  def next_question
    remaining_questions.sample
  end

  def remaining_questions
    questions.where.not(id: answers.where(correct: true).pluck(:question_id))
  end

  def correct_rate
    level.questions.count.to_f / answers.correct.count
  end

  def score
    (correct_rate * 100).round
  end
end

