class Answer < ActiveRecord::Base
  belongs_to :option
  belongs_to :user
  belongs_to :question

  def correct?
    option && option.correct?
  end

  def incorrect?
    option && !correct?
  end
end

