class Question < ActiveRecord::Base
  belongs_to :level
  has_many :answers
  belongs_to :exam
  has_one :course, through: :exam

  has_attached_file :attachment, styles: { default: "620x500" }

  default_scope -> { order('number ASC') }

  validates_uniqueness_of :text, scope: 'exam_id'

  def to_s
    text
  end

  def name
    to_s
  end

  def to_param
    [id, number, name.truncate(70).downcase.split(/\W+/)].join '-'
  end

  rails_admin do
    list do
      exclude_fields :created_at, :updated_at
    end
    edit do
      exclude_fields :answers, :course
    end
  end
end

