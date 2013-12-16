# Stripe public key
STRIPE_PUBLISHABLE_KEY = ENV['STRIPE_PUBLISHABLE_KEY'] # Set via $ heroku config:add STRIPE_PUBLISHABLE_KEY=publickey

# Site template variables
HEADLINE = "Title" # Appears at the top of all pages
BYLINE = "Byline" # Appears at the top of all pages
URL = "/" # Address of website, used for receipts
SITE_DESCRIPTION = "Description" # SEO description meta tag
SITE_KEYWORDS = "Keywords" # SEO keywords meta tag
ADMIN_NAME = "Author" # Added to receipts as well as the "Author" meta tag
ADMIN_EMAIL = "Your Name <you@yourdomain.com>" # Added to all emails and receipts 
FOOTER_CONTACT = "Copyright 2012, Company Inc. 123 Main Street, Sometown AA 12345, USA. 555-555-5555" # Appears at the bottom of all pages
FOOTER_LINKS = "<a href='/satisfaction'>Satisfaction Policy</a>. <a href='/disclosures'>Disclosures</a>. <a href='/privacy'>Privacy Policy</a>. <a href='/terms'>Terms of Service</a>. <a href='/contact'>Contact us</a>." # Appears at the bottom of all pages

# Offer details
OFFER_NAME = "Offer Name" # Appears on all pages, including receipts
OFFER_PRICE = "1000" # in cents, required by Stripe

# Mailgun settings
MAILGUN_API = ENV['MAILGUN_PRIVATE_KEY'] # Set via $ heroku config:add MAILGUN_PRIVATE_KEY=t0psecret
MAILGUN_DOMAIN = "domain.mailgun.org" # Your Mailgun domain
MAILGUN_LIST = "testing" # Your Mailgun mailing list name