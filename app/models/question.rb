class Question < ActiveRecord::Base
  has_paper_trail

  belongs_to :level
  belongs_to :exam
  has_one :course, through: :exam
  has_many :answers
  has_many :alerts

  has_attached_file :attachment, styles: { default: "620x500" }

  default_scope -> { order('number ASC') }

  validates_uniqueness_of :number, scope: 'exam_id'

  after_update do
    alerts.destroy_all
  end

  def to_param
    [id, number, name.downcase.split(/\W+/)].join '-'
  end

  def name
    text.truncate(100)
  end

  rails_admin do
    list do
      exclude_fields :created_at, :updated_at
    end
    edit do
      exclude_fields :course
    end
  end
end

