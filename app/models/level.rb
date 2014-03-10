class Level < ActiveRecord::Base
  has_many :questions
  belongs_to :course

  def to_s
    id
  end
end

