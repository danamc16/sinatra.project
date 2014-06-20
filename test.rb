require 'rufus-scheduler'
require 'HTTParty'

scheduler = Rufus::Scheduler.new

scheduler.at '2014/06/20 14:42:00' do

	url = "https://sendgrid.com/api/mail.send.json"
  
	response = HTTParty.post url, :body => {
	  "api_user" => "jdmcpeek",
	  "api_key" => "sendgridpro",
	  "to" => "josedmcpeek@gmail.com",
	  "from" => "josedmcpeek@gmail.com",
	  "subject" => "This is a test",
	  "text" => "SUCCESS"
	}

	response.body

end

scheduler.join