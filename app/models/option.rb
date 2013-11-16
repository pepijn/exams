class Option < ActiveRecord::Base
  belongs_to :question
  has_many :answers
  validates_presence_of :text

  default_scope -> { order 'id ASC' }

  def to_s
    text
  end

  def name
    to_s
  end

  def correct?
    self == question.correct_option
  end

  def placeholders?
    text.scan(/[{].+[}]/).present?
  end

  def no_placeholders
    text.gsub /[{].+[}]/, ''
  end

  def flatten_placeholders(remove_whitespace = true)
    (remove_whitespace ? no_markup : text).gsub /([{]|[}])/, ''
  end

  def no_markup
    text.gsub(/\s+/, "").downcase
  end
end

