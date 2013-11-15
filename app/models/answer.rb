class Answer < ActiveRecord::Base
  belongs_to :option
  belongs_to :session, dependent: :destroy
  belongs_to :question
  has_one :exam, through: :question
  has_one :course, through: :exam

  def correct?
    option && option.correct?
  end

  def incorrect?
    option && !correct?
  end
end

