require_relative 'config/application'

class Main < Sinatra::Base
  Warden::Manager.serialize_into_session { |id| id }
  Warden::Manager.serialize_from_session { |id| id }

  DataMapper::Logger.new($stdout, :debug)

  if settings.environment == :production
    Airbrake.configure do |config|
      config.api_key = '25015bc793ef0979d24ba6e0a093cbae'
    end

    use Airbrake::Rack
    enable :raise_errors

    database = 'exams'
  else
    database = 'exams_development'
  end

  DataMapper.setup :default, { database: database, adapter: 'postgres' }

  enable :sessions
  set :session_secret, "E6ahzGMJg77EDhRGE6ahzGMJg77EDhRGE6ahzGMJm"

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = FailureApp.new
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['name'] && params['user']['password']
    end

    def authenticate!
      user = User.authenticate(
        params['user']['email'],
        params['user']['password']
      )
      user.nil? ? fail!('Could not log in') : success!(user, 'Successfully logged in')
    end
  end

  def warden; env['warden']; end

  get '/login' do
    slim :login
  end

  post '/login' do
    warden.authenticate

    redirect '/exams'
  end

  get '/register' do
    slim :register
  end

  post '/register' do
    @user = User.new params[:user]

    return slim :register if !@user.valid? || !@user.password_valid?

    if @user.save
      warden.authenticate
      redirect '/'
    end
  end

  get '/' do
    @exam = Exam.first
    session[:question_ids] ||= Question.all.shuffle.map &:id
    session[:incorrect_answers] = 0

    unless @question = Question.get(session[:question_ids].first)
      session[:question_ids] = nil
      redirect '/'
    end

    @options = @question.options.shuffle
    session[:option_ids] = @options.map &:id

    @answer = Answer.last

    slim :test
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

    slim :test
  end

  get '/exams' do
    warden.authenticate!

    @exams = Exam.all
    slim :exams
  end

  post '/exams' do
    @exam = Exam.create date: params[:date]
    redirect '/exams'
  end

  get '/exams/:exam_id/questions' do
    @exam = Exam.get params[:exam_id]
    @questions = @exam.questions order: :number.asc
    slim :questions
  end

  get '/exams/:exam_id/questions/new' do
    @exam = Exam.get params[:exam_id]
    @question = @exam.questions.new
    @last_question = Question.last
    slim :new
  end

  get '/questions/:id' do
    @last_question = @question = Question.get params[:id]
    @exam = @question.exam

    slim :edit
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

  get '/error' do
    slim "Geen toegang"
  end
end

class FailureApp
  def call(env)
      uri = env['REQUEST_URI']
    puts 'failure: ' + env['REQUEST_METHOD'] + ' ' + uri
    [302, {'Location' => '/error?uri=' + CGI::escape(uri)}, '']
  end
end

