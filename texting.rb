require 'pry'
require 'sinatra'
require 'sinatra/reloader'

configure do
	enable :sessions
end


get '/' do
	erb :'index.html', :locals => {:history => session[:history]}
end

post '/' do
	erb :'index.html'
end