class Question < ActiveRecord::Base
  has_many :options
  has_many :answers
  belongs_to :exam

  def to_s
    text
  end

  def correct_option
    options.first
  end
end
