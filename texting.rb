require 'pry'
require 'sinatra'
require 'sinatra/reloader'

configure do
	enable :sessions
end


get '/' do
	session[:groups] ||= {}
	session[:texts] ||= {}
	
	erb :'index.html', :locals => {:texts => session[:texts],:groups => session[:groups]}
end

post '/' do

	member = params[:membername]
	
	number = params[:number]

	groupname = params[:groupname]

	session[:groups][groupname] ||= {}
	session[:groups][groupname][member] = number



	erb :'index.html', :locals => {:texts => session[:texts],:groups => session[:groups], :member => params[:membername], :number => params[:number], :groupname => params[:groupname]}
end

get '/:groupname' do


	erb :'specificgroup.html', :locals => {:groups => session[:groups],  :groupname => params[:groupname], :button => params[:button],:text => session[:text]}
end

post '/:groupname' do

	recipients = params[:recipients]
	message = params[:message]
	time = params[:time]

	session[:text][recipients] ||= {}
	session[:text][recipients] = [time,message]




	erb :'specificgroup.html', :locals => {:groups => session[:groups],:member => params[:membername], :number => params[:number],:groupname => params[:groupname],:recipients => recipients,:message => message,:time => time,:text => session[:text]}

end
