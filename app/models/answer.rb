class Answer < ActiveRecord::Base
  belongs_to :option
  belongs_to :session, dependent: :destroy
  belongs_to :question
  has_one :exam, through: :question
  has_one :course, through: :exam
  has_one :user, through: :session

  scope :real, -> { where('option_id != 0 OR input IS NOT NULL') }

  def pass?
    !option && !input
  end

  def correct?
    return nil if pass?
    return option.correct? if option
    input.downcase.strip == question.correct_option.text.downcase.strip
  end

  def name
    option ? option.text : input
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

