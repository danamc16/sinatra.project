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
	session[:user_email] ||= "josedmcpeek@gmail.com"

	
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
								   :groupname => params[:groupname],}
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


	user_email = params[:user_email]

	session[:user_email] = user_email
	
	subject = params[:subject]
	message = params[:message]
	time = params[:time]
	date = params[:date].split("-").join("/")
	frequency = params[:frequency]
	count = params[:count].to_i
	session[:emails] ||= {}
	session[:emails][groupname] ||= []
	session[:emails][groupname].push([recipients,time,date,subject,message])


	scheduler = Rufus::Scheduler.new

	delivery_time = date.to_s + ' ' + time.to_s + ':00' 

	compare = session[:groups][groupname].keys & recipients
	
	scheduler.at delivery_time do

		scheduler.every frequency, :times => count do


		url = "https://sendgrid.com/api/mail.send.json"
	  
		response = HTTParty.post url, :body => {
		  "api_user" => "jdmcpeek",
		  "api_key" => "sendgridpro",
		  "to" => session[:groups][groupname].select{|k,v| compare.include? k }.values,
		  "from" => session[:user_email],
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
										   :date => date,
										   :emails => session[:emails],
										   :display => display,
										   :user_email => :user_email,
										   :frequency => frequency,
										   :count => count}

end

get '/:groupname/edit' do


	erb :'edit.html', :locals => {  :groups => session[:groups],
									:member => params[:membername], 
									:email => params[:email],
									:groupname => params[:groupname],
									:emails => session[:emails],
									:display => display}

end

put '/:groupname/edit' do

	groupname = params[:groupname]
	groupname_new = params[:groupname_new]
	session[:groups][groupname_new] = session[:groups].delete(groupname)

	session[:groups][groupname_new].keys.each do |oldname|
		newname = params[oldname.to_sym]
		session[:groups][groupname_new][newname] = session[:groups][groupname_new].delete(oldname)
		session[:groups][groupname_new][newname].replace(params[session[:groups][groupname_new][newname].to_sym])
	end

	redirect to('/' + groupname_new)

	erb :'edit.html', :locals => {:groups => session[:groups],
								  :member => params[:membername], 
								  :email => params[:email],
								  :groupname => params[:groupname],
								  :groupname_new => groupname_new}

end

delete '/:groupname/edit' do
	groupname = params[:groupname]
	session[:groups].delete(groupname)
	redirect to('/')
	erb :'edit.html', :locals => {:groupname => groupname}
end
