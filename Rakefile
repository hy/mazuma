require 'rubygems'
require 'json'
require 'rest-client'
require 'multimap'
require 'rake'
require './config/globals'

namespace :email do 

  # Sends preview of email to administrator
  task :preview, :subject, :message_id, :attachment do |t, args|
  
    puts "Sending preview of '#{args.subject}' to #{ADMIN_EMAIL}"
    
    file = File.open("./email/messages/#{args.message_id}", "rb").read
    attachment = File.new("./email/attachments/#{args.attachment}")
  
    data = Multimap.new
    data[:to] = "#{ADMIN_EMAIL}"
    data[:from] = "#{ADMIN_EMAIL}"
    data[:subject] = "#{args.subject}"
    data[:html] = file
    data[:attachment] = attachment
  
    RestClient.post "https://api:#{MAILGUN_API}"\
      "@api.mailgun.net/v2/#{MAILGUN_DOMAIN}/messages", data
  
    puts "Sent preview of '#{args.message_id}' to #{ADMIN_EMAIL}"
    
  end
  
  # Sends email to Mailgun broadcast list
  task :broadcast, :subject, :message_id, :attachment do |t, args|
  
    puts "Sending broadcast of '#{args.subject}' to #{ADMIN_EMAIL}"
    
    file = File.open("./email/messages/#{args.message_id}", "rb").read
    attachment = File.new("./email/attachments/#{args.attachment}")
  
    data = Multimap.new
    data[:to] = "#{MAILGUN_LIST}@#{MAILGUN_DOMAIN}"
    data[:from] = "#{ADMIN_EMAIL}"
    data[:subject] = "#{args.subject}"
    data[:html] = file
    data[:attachment] = attachment
  
    RestClient.post "https://api:#{MAILGUN_API}"\
      "@api.mailgun.net/v2/#{MAILGUN_DOMAIN}/messages", data

    puts "Sent broadcast of '#{args.message_id}' to #{MAILGUN_LIST}@#{MAILGUN_DOMAIN}"
    
  end
  
end