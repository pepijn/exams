class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :coupon

  has_many :sessions
  has_many :answers, through: :sessions
  has_many :orders

  def to_s
    email
  end

  def name
    to_s
  end

  def total_credits
    orders.paid.map(&:credits).inject(:+) || 0
  end

  def remaining_credits
    total_credits - answers.real.count
  end

  def credits_remaining?
    remaining_credits <= 0
  end

  def session
    last_session = sessions.last || return
    last_session if last_session.question_stack.present?
  end

  def course
    sessions.last.course if sessions.last
  end

  def hard_questions
    answers.includes(question: :options).map do |answer|
      answer.question if answer.question && answer.question.options.first.id != answer.option_id
    end.compact.uniq
  end
end

