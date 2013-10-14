DataMapper::Logger.new($stdout, :debug)

#log = File.new("#{settings.root}/log/#{settings.environment}.log", 'a')
#$stdout.reopen(log)
#$stderr.reopen(log)

if settings.environment == :production
  Airbrake.configure do |config|
    config.api_key = '25015bc793ef0979d24ba6e0a093cbae'
  end

  use Airbrake::Rack
  enable :raise_errors

  database =  'exams'
else
  database = 'exams_development'
end

DataMapper.setup :default, { database: database, adapter: 'postgres' }

enable :sessions
set :session_secret, "E6ahzGMJg77EDhRGE6ahzGMJg77EDhRGE6ahzGMJm"

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

DataMapper.finalize
DataMapper.auto_upgrade!

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

get '/exams' do
  @exams = Exam.all
  haml :exams
end

post '/exams' do
  @exam = Exam.create date: params[:date]
  redirect '/exams'
end

get '/exams/:exam_id/questions' do
  @exam = Exam.get params[:exam_id]
  @questions = @exam.questions order: :number.asc
  haml :questions
end

get '/exams/:exam_id/questions/new' do
  @exam = Exam.get params[:exam_id]
  @question = @exam.questions.new
  @last_question = Question.last
  haml :new
end

get '/questions/:id' do
  @last_question = @question = Question.get params[:id]
  @exam = @question.exam

  haml :edit
end

post '/questions/:id' do
  question = Question.get params[:id]
  question.update params[:question]

  (0..4).each do |index|
    option = question.options[index]
    text = params[:options][index]

    option.update text: text if option && !text.empty?
    option.destroy if option && text.empty?
    question.options.create text: text if option.nil?
  end

  redirect "/questions/#{question.id}"
end

post '/exams/:exam_id/questions' do
  exam = Exam.get params[:exam_id]
  question = exam.questions.create params[:question]

  params[:options].each do |option|
    question.options.create text: option
  end

  redirect "/exams/#{exam.id}/questions/new"
end

delete '/questions/:id' do
  @question = Question.get params[:id]
  @question.destroy!

  redirect "/exams/#{@question.exam_id}/questions"
end

get '/application.js' do
  coffee :application
end

