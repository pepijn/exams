class Answer < ActiveRecord::Base
  belongs_to :option
  has_one :question, through: :option

  def correct?
    option && option.correct?
  end
end

