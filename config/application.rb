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


require_relative '../models'

