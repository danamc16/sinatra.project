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

	# return session[params[groupname]]
	recipients = ""
	time = DateTime.now()
	message = ""
	
	display = false


	erb :'specificgroup.html', :locals => {:groups => session[:groups],  :groupname => params[:groupname], :button => params[:button],:texts => session[:texts], :recipients => recipients,:message => message,:time => time,:display => display}
end

post '/:groupname' do



	recipients = params[:recipients]
	message = params[:message]
	time = params[:time]
	session[:texts] ||= {}
	session[:texts][recipients] ||= {}
	session[:texts][recipients] = [time,message]

	display = true


	erb :'specificgroup.html', :locals => {:groups => session[:groups],:member => params[:membername], :number => params[:number],:groupname => params[:groupname],:recipients => recipients,:message => message,:time => time,:texts => session[:texts],:display => display}

end
