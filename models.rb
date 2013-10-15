class Exam
  include DataMapper::Resource

  property :id,   Serial
  property :date, Date

  has n, :questions, constraint: :destroy

  validates_presence_of :date
  validates_uniqueness_of :date
end

class Question
  include DataMapper::Resource

  property :id,     Serial
  property :number, Integer
  property :text,   Text

  timestamps :at

  belongs_to :exam
  has n, :options, constraint: :destroy
  has n, :answers, through: :options

  validates_presence_of :text

  def to_s
    text
  end

  def correct_option
    options.first
  end
end

class Option
  include DataMapper::Resource

  property :id,   Serial
  property :text, String, length: 255

  timestamps :at

  belongs_to :question
  has n, :answers, constraint: :destroy

  validates_presence_of :text

  def to_s
    text
  end

  def correct?
    self == question.correct_option
  end
end

class Answer
  include DataMapper::Resource

  property :id, Serial

  belongs_to :option
  has 1, :question, through: :option

  timestamps :at

  def correct?
    option.correct?
  end

  def incorrect?
    !correct?
  end
end

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, required: true
  property :password, BCryptHash, required: true

  attr_accessor :password_confirmation

  def self.authenticate(email, password)
    user = self.first email: email
    user if user && user.password == password
  end

  def password_valid?
    password == password_confirmation
  end
end

DataMapper.finalize

