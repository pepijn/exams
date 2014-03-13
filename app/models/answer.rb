class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :session
  belongs_to :user

  has_one :level, through: :question
  has_one :exam, through: :question
  has_one :course, through: :exam

  validates_presence_of :session, :user, :question

  scope :correct,   where(correct: true)
  scope :incorrect, where(correct: false)

  def name
    input
  end

  def no_markup
    input.gsub(/\s+/, "").downcase
  end

  rails_admin do
    list do
      field :user
      field :exam
      field :question
      field :correct?, :boolean
      field :created_at
    end
  end
end

