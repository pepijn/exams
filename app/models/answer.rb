class Answer < ActiveRecord::Base
  belongs_to :option
  has_one :question, through: :option

  def correct?
    option.correct?
  end
end

