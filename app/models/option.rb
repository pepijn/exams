class Option < ActiveRecord::Base
  belongs_to :question
  has_many :answers
  validates_presence_of :text

  default_scope -> { order 'id ASC' }

  def to_s
    text
  end

  def correct?
    self == question.correct_option
  end
end

