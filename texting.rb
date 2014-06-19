require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'Time'

configure do
	enable :sessions
end


get '/' do
	session[:groups] ||= {}
	session[:texts] ||= {}
	
	erb :'index.html', :locals => {:texts => session[:texts],
								   :groups => session[:groups]}
end

post '/' do

	member = params[:membername]
	
	number = params[:number]

	groupname = params[:groupname]

	session[:groups][groupname] ||= {}
	session[:groups][groupname][member] = number



	erb :'index.html', :locals => {:texts => session[:texts],
								   :groups => session[:groups], 
								   :member => params[:membername], 
								   :number => params[:number], 
								   :groupname => params[:groupname]}
end

get '/:groupname' do	

	session[:texts] ||= {}

	groupname = params[:groupname]
	session[:texts][groupname] ||= []

	recipients = ""
	time = Time.now.strftime("%H:%M")
	message = ""

	


	erb :'specificgroup.html', :locals => {:groups => session[:groups],  
										   :texts => session[:texts], 
										   :groupname => params[:groupname], 
										   :button => params[:button],
										   :texts => session[:texts], 
										   :recipients => recipients,
										   :message => message,
										   :time => time}
end

post '/:groupname' do

	groupname = params[:groupname]

	recipients = []
	
	session[:groups][groupname].keys.each do |name|
		if params[name] == "on"
			recipients.push(name)
		end

	end
	
	message = params[:message]
	time = params[:time]
	session[:texts] ||= {}
	session[:texts][groupname] ||= []
	session[:texts][groupname].push([recipients,time,message])


	erb :'specificgroup.html', :locals => {:groups => session[:groups],
										   :member => params[:membername], 
										   :number => params[:number],
										   :groupname => params[:groupname],
										   :recipients => recipients,
										   :message => message,
										   :time => time,
										   :texts => session[:texts],
										   :display => display}

end

get '/:groupname/edit' do


	erb :'edit.html', :locals => {  :groups => session[:groups],
									:member => params[:membername], 
									:number => params[:number],
									:groupname => params[:groupname],
									:texts => session[:texts],
									:display => display}

end
