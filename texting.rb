require 'pry'
require 'sinatra'
require 'sinatra/reloader'

configure do
	enable :sessions
end


get '/' do
	session[:groups] ||= {}
	
	erb :'index.html', :locals => {:groups => session[:groups]}
end

post '/' do

	member = params[:membername]
	
	number = params[:number]

	groupname = params[:groupname]

	session[:groups][groupname] ||= {}
	session[:groups][groupname][member] = number



	erb :'index.html', :locals => {:groups => session[:groups], :member => params[:membername], :number => params[:number], :groupname => params[:groupname]}
end

get '/:groupname' do





	erb :'specificgroup.html', :locals => {:groups => session[:groups], :member => params[:membername], :number => params[:number], :groupname => params[:groupname], :button => params[:button]}
end
