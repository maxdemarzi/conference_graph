# encoding: utf-8
cg_dir = File.expand_path('../cg', __FILE__)
$:.unshift(cg_dir) unless $:.include? cg_dir

require 'sidekiq/middleware/server/unique_jobs'
require 'sidekiq/middleware/client/unique_jobs'

Sidekiq.configure_server do |config|
  config.redis = { :url => ENV['REDISTOGO_URL'] }
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::UniqueJobs
  end
end    

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDISTOGO_URL'] }
  config.client_middleware do |chain|
    chain.add Sidekiq::Middleware::Client::UniqueJobs
  end
end

Twitter.configure do |config|
  config.consumer_key    = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
end


require 'models/user'
require 'jobs/import_twitter_follows'
