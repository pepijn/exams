class Course < ActiveRecord::Base
  has_many :exams
  has_many :questions, through: :exams

  def to_s
    name
  end
end
