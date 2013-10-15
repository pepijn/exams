class Option < ActiveRecord::Base
  belongs_to :question
  has_many :answers

  def to_s
    text
  end

  def correct?
    self == question.correct_option
  end
end
