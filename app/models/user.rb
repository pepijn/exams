class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :coupon

  has_many :answers
  has_many :orders
  has_many :sessions

  validates :student_number, presence: true, numericality: true

  def to_s
    email.split("@").first
  end

  def name
    to_s
  end

  def total_credits
    (orders.paid.map(&:credits).inject(:+) || 0) + (created_at < "Thu, 19 Dec 2013 19:15 CET +01:00".to_time ? 100 : 0)# 100 is cadeautje
  end

  def remaining_credits
    total_credits - answers.count
  end

  def credits_remaining?
    remaining_credits <= 0
  end

  def hard_questions(course)
    answers = course.answers.where(user: self)

    score = {}
    answers.each do |answer|
      score[answer.question_id] ||= 0
      score[answer.question_id] += answer.correct? ? 1 : -1
      score[answer.question_id]
    end

    score.reject! { |_,score| score > 0 }

    Question.where(id: score.keys)
  end

  rails_admin do
    list do
      field :email
      field :total_credits
      field :remaining_credits
      field :current_sign_in_at
    end
  end
end

