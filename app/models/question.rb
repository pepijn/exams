class Question < ActiveRecord::Base
  has_many :options
  has_many :answers
  belongs_to :exam
  has_one :course, through: :exam

  accepts_nested_attributes_for :options

  def to_s
    text
  end

  def correct_option
    options.first
  end
end
