class Course < ActiveRecord::Base
  has_many :exams
  has_many :questions, through: :exams
  has_many :answers, through: :questions

  def to_s
    name
  end
end
