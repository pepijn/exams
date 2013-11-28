class Question < ActiveRecord::Base
  has_many :options
  has_many :answers
  belongs_to :exam
  has_one :course, through: :exam

  has_attached_file :attachment, styles: { default: "620x500" }

  accepts_nested_attributes_for :options
  default_scope -> { order('number ASC') }

  def to_s
    text
  end

  def name
    to_s
  end

  def correct_option
    options.first
  end

  def multiple_choice?
    options.length > 1
  end

  def to_param
    [id, number, name.truncate(70).downcase.split(/\W+/)].join '-'
  end

  rails_admin do
    edit do
      exclude_fields :options, :answers, :course
    end
  end
end

