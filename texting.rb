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
	groupname = params[:groupname]
	recipients = params[:recipients]
	binding.pry
	message = params[:message]
	time = params[:time]

	session[:text][groupname] ||= {}
	session[:text][groupname] ||= {}
	session[:text][groupname] = [recipients,time,message]




	erb :'specificgroup.html', :locals => {:groups => session[:groups],:member => params[:membername], :number => params[:number],:groupname => params[:groupname],:recipients => recipients,:message => message,:time => time,:text => session[:text],:multiple => true,:prompt =>'select names'}

end
