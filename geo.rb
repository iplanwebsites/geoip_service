require 'rubygems'
require 'cgi'

require "bundler"
Bundler.setup

require 'rack'
require 'sinatra'
require "sinatra/reloader" if development?
require 'json'
require 'geoip'

configure :production do
  require 'newrelic_rpm'
end

configure do
  GEOIP = GeoIP.new('GeoLiteCity.dat')
end

get '/' do
  'OK'
end

get '/location.json' do
  content_type :json, :charset => "utf-8"
  headers['Cache-Control'] = "public; max-age=#{365*24*60*60}"

  returnable = {:message => "you didn't supply an IP to geocode!"}
  returnable = GEOIP.city(params[:ip]).to_hash if params[:ip]

  returnable.to_json
end