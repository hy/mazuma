require 'sinatra'
require 'stripe'
require 'json'
require 'rest-client'
require 'multimap'

post '/stripe-receipt-mailer' do
  
  Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  data = JSON.parse request.body.read, :symbolize_names => true
  p data
  
  puts "Received event with ID: #{data[:id]} Type: #{data[:type]}"
  
  # Retrieving the event from the Stripe API guarantees its authenticity  
  event = Stripe::Event.retrieve(data[:id])
  
  # This will send receipts on succesful charges to the associated Offer Name
  if event.type == "charge.succeeded" && event.data.object.description == "#{OFFER_NAME}"
    email_charge_receipt(event.data.object)
    add_subscriber(event.data.object)
  end
  
end

def email_charge_receipt(charge)
  
  customer = Stripe::Customer.retrieve(charge.customer)
  
  puts "Emailing customer for charge: #{charge.id} amount: #{format_stripe_amount(charge.amount)}"
  
  data = Multimap.new
  data[:from] = "#{ADMIN_EMAIL}"
  data[:to] = "#{customer.email}"
  data[:subject] = "Receipt: #{OFFER_NAME} - #{URL}"
  data[:text] = payment_received_body(charge, customer)
  # data[:attachment] = File.new(File.join("files", "test.jpg"))
  
  RestClient.post "https://api:#{MAILGUN_API}"\
    "@api.mailgun.net/v2/#{MAILGUN_DOMAIN}/messages", data
  
  puts "Email sent to #{customer.email}"

end

def add_subscriber(charge)
  
  customer = Stripe::Customer.retrieve(charge.customer)
  
  puts "Adding #{customer.email} to mailing list #{MAILGUN_LIST}"
  
  data = Multimap.new
  data[:subscribed] = true
  data[:address] = "#{customer.email}"
  data[:name] = "#{customer.description}"
  
  RestClient.post "https://api:#{MAILGUN_API}"\
    "@api.mailgun.net/v2/lists/#{MAILGUN_LIST}@#{MAILGUN_DOMAIN}/members", data
  
  puts "Customer {customer.email} added to email list"
    
end

def format_stripe_amount(amount)
  sprintf('$%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
end

def format_stripe_timestamp(timestamp)
  Time.at(timestamp).strftime("%m/%d/%Y")
end

def payment_received_body(charge, customer)
  <<EOF
Dear #{customer.description}:

A successful charge has been placed for #{OFFER_NAME}, via #{URL}. This is your receipt.

#{customer.description}
#{customer.email}
#{charge.card.address_line1}, #{charge.card.address_line2}
#{charge.card.address_state}, #{charge.card.address_zip}, #{charge.card.address_country}

Amount: #{format_stripe_amount(charge.amount)} (USD)
Card: #{charge.card.type} ending in #{charge.card.last4}
Transaction ID: #{charge.id}

Thank you for your business!

Sincerely,

#{ADMIN_NAME}
#{ADMIN_EMAIL}
#{FOOTER_CONTACT}

-------------------------------------------------

EOF
end