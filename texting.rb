require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'Time'
require 'httparty'
require 'rufus-scheduler'

configure do
	enable :sessions
end


get '/' do
	session[:groups] ||= {}
	session[:emails] ||= {}
	
	erb :'index.html', :locals => {:emails => session[:emails],
								   :groups => session[:groups]}
end

post '/' do

	member = params[:membername]
	
	email = params[:email]

	groupname = params[:groupname]

	session[:groups][groupname] ||= {}
	session[:groups][groupname][member] = email



	erb :'index.html', :locals => {:emails => session[:emails],
								   :groups => session[:groups], 
								   :member => params[:membername], 
								   :email => params[:email], 
								   :groupname => params[:groupname]}
end

get '/:groupname' do	

	session[:emails] ||= {}

	groupname = params[:groupname]
	session[:emails][groupname] ||= []

	recipients = ""
	time = Time.now.strftime("%H:%M")
	subject = ""
	message = ""

	


	erb :'specificgroup.html', :locals => {:groups => session[:groups],  
										   :emails => session[:emails], 
										   :groupname => params[:groupname], 
										   :button => params[:button],
										   :emails => session[:emails], 
										   :recipients => recipients,
										   :subject =>
										   	   subject,
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
	
	subject = params[:subject]
	message = params[:message]
	time = params[:time]
	session[:emails] ||= {}
	session[:emails][groupname] ||= []
	session[:emails][groupname].push([recipients,time,subject,message])


	scheduler = Rufus::Scheduler.new

	delivery_time = '2014/06/20 ' + time.to_s + ':00' 



	scheduler.at delivery_time do

		scheduler.every '30s', :times => 2 do


		url = "https://sendgrid.com/api/mail.send.json"
	  
		response = HTTParty.post url, :body => {
		  "api_user" => "jdmcpeek",
		  "api_key" => "sendgridpro",
		  "to" => session[:groups][groupname].values,
		  "from" => "josedmcpeek@gmail.com",
		  "subject" => subject,
		  "text" => message
		}

		response.body

		end	
	end







	erb :'specificgroup.html', :locals => {:groups => session[:groups],
										   :member => params[:membername], 
										   :email => params[:email],
										   :groupname => params[:groupname],
										   :recipients => recipients,
										   :subject => subject,
										   :message => message,
										   :time => time,
										   :emails => session[:emails],
										   :display => display}

end

get '/:groupname/edit' do


	erb :'edit.html', :locals => {  :groups => session[:groups],
									:member => params[:membername], 
									:email => params[:email],
									:groupname => params[:groupname],
									:emails => session[:emails],
									:display => display}

end
