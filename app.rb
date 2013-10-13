# encoding: utf-8

configure do
  require 'json'

  enable :sessions
  set :session_secret, "E6ahzGMJg77EDhRGE6ahzGMJg77EDhRGE6ahzGMJm"

  if settings.environment == :production
    DataMapper.setup :default, ENV['HEROKU_POSTGRESQL_RED_URL']

  else
    DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup :default, 'postgres://localhost/exams_development'
  end
end

class Question
  include DataMapper::Resource

  property :id,     Serial
  property :number, Integer
  property :text,   String, length: 255

  timestamps :at

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

DataMapper.finalize

get '/reset' do
  DataMapper.auto_migrate!

  q1 = Question.create number: 1, text: "Welk genproduct komt wel in de voetplaat maar niet in de handplaat tot expressie?"
  q1.options.create text: 'Tbx4'
  q1.options.create text: 'Tbx5'
  q1.options.create text: 'Hox C6'
  q1.options.create text: 'Hox D6'

  q2 = Question.create number: 2, text: "Welk van onderstaande bevindingen past bij een posterieure homeote transformatie?"
  q2.options.create text: 'halsribben'
  q2.options.create text: 'lenderibben'
  q2.options.create text: 'gescraliseerde stuitwervel'
  q2.options.create text: 'gelumbaliseerde heligbeenwervel'

  q3 = Question.create number: 3, text: "Bij welke skeletdysplasie is de lengte ontwikkeling van de lange pijpbeenderen in eerste instantie normaal?"
  q3.options.create text: 'osteogenesis imperfecta'
  q3.options.create text: 'atelosteogenesis'
  q3.options.create text: 'hypochondroplasie'
  q3.options.create text: 'thanatophoredysplasie'

  redirect '/'
end

get '/' do
  session[:question_ids] ||= Question.all.shuffle.map &:id
  session[:incorrect_answers] = 0

  unless @question = Question.get(session[:question_ids].first)
    session[:question_ids] = nil
    redirect '/'
  end

  @options = @question.options.shuffle
  session[:option_ids] = @options.map &:id

  @answer = Answer.last

  haml :test
end

post '/' do
  @option = Option.get params[:option]
  @question = @option.question
  @answer = @option.answers.create
  @options = Option.all id: session[:option_ids]

  if @answer.correct?
    session[:question_ids].shift
    return redirect '/'
  end

  session[:incorrect_answers] += 1

  haml :test
end

get '/questions' do
  @questions = Question.all order: :number.asc
  haml :index
end

get '/questions/new' do
  @question = Question.new
  @last_question = Question.last
  haml :new
end

get '/questions/:id' do
  @last_question = @question = Question.get params[:id]
  haml :edit
end

post '/questions' do
  question = Question.create params[:question]

  params[:options].each do |option|
    question.options.create text: option
  end

  redirect '/questions/new'
end

delete '/questions/:id' do
  @question = Question.get params[:id]
  @question.destroy!

  redirect '/questions'
end

get '/application.js' do
  coffee :application
end

