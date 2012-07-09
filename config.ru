# -*- encoding: utf-8 -*-
ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require 'sinatra/config_file'
require 'sinatra/reloader' if development?
require 'sidekiq/web'
require './lib/cg'
require './cg_api'
require './cg_app'

map '/' do
  run CG::App
end

map '/api' do
  run CG::Api
end

map '/sidekiq' do
  run Sidekiq::Web
end