class Answer < ActiveRecord::Base
  belongs_to :question
  has_one :level, through: :question
  has_one :exam, through: :question
  has_one :course, through: :exam
  belongs_to :user

  validates_presence_of :input

  scope :real, -> { where('option_id > 0 OR input IS NOT NULL') }

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

