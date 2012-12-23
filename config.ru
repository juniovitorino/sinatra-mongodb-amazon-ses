require 'rubygems'
require 'bundler'
require 'sinatra'
require 'rack/rewrite'
require 'aws/ses'
require 'sanitize'
require 'mongoid'
require 'open-uri'
require 'pry' if ENV['RACK_ENV'] != "production"
require "better_errors" if ENV['RACK_ENV'] != "production"

Dir["./models/**/*.rb"].each { |file| require file }
Dir["./utils/**/*.rb"].each  { |file| require file }

require './application'

run Application