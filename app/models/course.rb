class Course < ActiveRecord::Base
  has_many :exams
  has_many :questions, through: :exams
  has_many :answers, through: :questions

  def to_s
    name
  end

  rails_admin do
    edit do
      field :name
    end
  end
end
