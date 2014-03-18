class Level < ActiveRecord::Base
  has_many :questions
  belongs_to :course

  def name
    label && label.present? ? label : "Thema #{number}"
  end
end

