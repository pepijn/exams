class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :coupon

  has_many :answers
  has_many :sessions

  def to_s
    email
  end

  def session
    last_session = sessions.last || return
    last_session if last_session.question_stack.present?
  end

  def course
    sessions.last.course if sessions.last
  end
end

