def send_simple_message
  RestClient.post "https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0"\
  "@api.mailgun.net/v2/samples.mailgun.org/messages",
  :from => "David McPeek <josedmcpeek@gmail.com>",
  :to => "david.mcpeek@yale.edu",
  :subject => "Hello",
  :text => "Testing some Mailgun awesomeness!"
end