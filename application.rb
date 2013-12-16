require 'rubygems'
require 'puma'
require 'sinatra'
require 'rack/csrf'
require 'json'
require 'rest-client'
require 'multimap'
require 'stripe'
require 'rack-ssl-enforcer'

# Global application settings
set :public_folder, Proc.new { File.join(root, "public") }
set :views, File.dirname(__FILE__) + "/views"
set :static, true
set :default_encoding, "UTF-8"
set :locale, "en"

# Require config files
require './config/environments/' + settings.environment.to_s
require './config/globals'

# Rack configuration
# use Rack::SslEnforcer # enable in production

### Secure Cookies
use Rack::Session::Cookie, { :http_only => true, :secure => true, :expire_after => 14400 }

### CSRF
configure do
  use Rack::Session::Cookie, { :secret => "CHANGEMEYOUFOOL" }
  use Rack::Csrf, :raise => true, :skip => ['']
end

helpers do
  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end
end

# Security helpers
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# Require module files
Dir['./modules/**/*.rb'].each { |f| require(f) }

# Index handler
get '/?' do
  @title = OFFER_NAME
  erb :index
end

# Order handler
get '/order/?' do
  @title = OFFER_NAME
  erb :order
end

# Success handler
get '/success/?' do
  @title = OFFER_NAME
  erb :success
end

# Order handler
post '/order/?' do
  
  begin
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    
    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    
    customer = Stripe::Customer.create(
      :card => token,
      :email => params[:email],
      :description => params[:name]
    )
    
    # Create the charge on Stripe's servers - this will charge the user's card
    # Add :plan => "plan-id" if order is a subscription
    @charge = Stripe::Charge.create(
        :amount => OFFER_PRICE,
        :currency => "usd",
        :customer => customer.id,
        :description => OFFER_NAME
    )
  
  rescue Stripe::CardError
      erb :error
  end
  
  erb :success
  
end

get '/satisfaction/?' do
  @title = OFFER_NAME + " - Satisfaction Policy"
  erb :satisfaction
end

get '/disclosures/?' do
  @title = OFFER_NAME + " - Disclosures"
  erb :disclosures
end

get '/privacy/?' do
  @title = OFFER_NAME + " - Privacy Policy"
  erb :privacy
end

get '/terms/?' do
  @title = OFFER_NAME + " - Terms of Service"
  erb :terms
end

get '/contact/?' do
  @title = OFFER_NAME + " - Contact"
  erb :contact
end

not_found do
  erb :notfound
end

error do
  erb :error
end