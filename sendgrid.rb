# require "httparty"
# url = "https://sendgrid.com/api/mail.send.json"

# response = HTTParty.post url, :body => {
#   "api_user" => "jdmcpeek",
#   "api_key" => "sendgridpro",
#   "to" => ["dana.chaykovsky@yale.edu", "josedmcpeek@gmail.com"],
#   "from" => "josedmcpeek@gmail.com",
#   "subject" => "Hello world",
#   "text" => "Hey Dana"
# }

# response.body

require 'mail'
Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :domain    => "yourdomain.com",
                           :user_name => "yourusername@domain.com",
                           :password  => "yourPassword",
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end

mail = Mail.deliver do
  to 'yourRecipient@domain.com'
  from 'Your Name <name@domain.com>'
  subject 'This is the subject of your email'
  text_part do
    body 'Hello world in text'
  end
  html_part do
    content_type 'text/html; charset=UTF-8'
    body '<b>Hello world in HTML</b>'
  end
end