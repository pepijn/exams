# encoding: utf-8

configure do
  require 'json'

  enable :sessions
  set :session_secret, ENV['HEROKU_POSTGRESQL_RED_URL']

  if settings.environment == :production
    DataMapper.setup :default, {

  else
    DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup :default, 'postgres://localhost/exams_development'
  end
end

class Question
  include DataMapper::Resource

  timestamps :at

  property :id,   Serial
  property :text, String

  has n, :options
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

  timestamps :at

  property :id,   Serial
  property :text, String

  belongs_to :question
  has n, :answers

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

  timestamps :at

  property :id, Serial

  belongs_to :option

  def correct?
    option.correct?
  end

  def incorrect?
    !correct?
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  @question = Question.first
  @options = @question.options.shuffle
  session[:option_ids] = @options.map &:id
  haml :test
end

post '/' do
  @option = Option.get params[:option]
  @question = @option.question
  @answer = @option.answers.create
  @options = Option.all id: session[:option_ids]

  return redirect '/' if @answer.correct?
  haml :test
end

get '/questions' do
  @questions = Question.all
  haml :index
end

get '/questions/new' do
  @question = Question.new
  @last_question = Question.last
  haml :new
end

get '/questions/:id' do
  @question = Question.get params[:id]
  haml :edit
end

post '/questions' do
  question = Question.create text: params[:question]

  params[:options].each do |option|
    question.options.create text: option
  end

  redirect '/questions/new'
end

delete '/questions/:id' do
  @question = Question.get params[:id]
  @question.options.destroy!
  @question.destroy!

  redirect '/questions'
end

get '/application.js' do
  coffee :application
end

