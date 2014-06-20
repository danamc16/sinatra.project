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
	date = params[:date]
	session[:emails] ||= {}
	session[:emails][groupname] ||= []
	session[:emails][groupname].push([recipients,time,date,subject,message])

	#url = "https://sendgrid.com/api/mail.send.json"
  
	#response = HTTParty.post url, :body => {
	#  "api_user" => "jdmcpeek",
	#  "api_key" => "sendgridpro",
	#  "to" => session[:groups][groupname].values,
	#  "from" => "josedmcpeek@gmail.com",
	 # "subject" => "This is a test",
	#  "text" => message
	#}

	#response.body


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

put '/:groupname/edit' do

	groupname = params[:groupname]
	groupname_new = params[:groupname_new]
	session[:groups][title_new] = session[:groups].delete(title)




	#groupname_new = params[:groupname_new]
	#session[:groups][title_new] = session[:groups].delete(title)

	#description = params[:description]
	#vidlist = params[:vidlist].split(', ')
	#history[title_new].replace(vidlist.push(description))
	#redirect to('/sets/' + title_new)
	
	erb :'edit.html', :locals => {:groups => session[:groups],
										   :member => params[:membername], 
										   :email => params[:email],
										   :groupname => params[:groupname]}

end

delete '/:groupname/edit' do
	groupname = params[:groupname]
	session[:groups].delete(groupname)
	redirect to('/')
	erb :setname, :locals => {:groupname => groupname}
end
