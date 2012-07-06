# encoding: utf-8
libdir = File.expand_path('../lib', __FILE__)
$:.unshift(libdir) unless $:.include? libdir

ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']

require 'bundler'
Bundler.require

require 'cg'
