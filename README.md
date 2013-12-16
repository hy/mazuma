Mazuma - a sales app built on Heroku, Stripe, and Mailgun
=========================================================

**Mazuma is a simple sales application written in Ruby.** It uses [Sinatra](http://www.sinatrarb.com/) and [ERB](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html) templates to produce an attractive two-column web application suitable for selling a product, service, or subscription online. The application is capable of delivering a file download link on a successful transaction and/or sending the file as an email attachment.

Mazuma is designed for easy deployment to [Heroku's](http://heroku.com). [Stripe](http://stripe.com) is used to charge the user's credit card, and [Mailgun](http://mailgun.net) is used to send the user a receipt for successful transactions, as well as send all purchasers update emails via a simple command line interface. [Mailcheck.js](https://github.com/Kicksend/mailcheck) automatically catches common email typos.

All pages in the application default to SSL via [rack-ssl-enforcer](https://github.com/tobmatth/rack-ssl-enforcer). Using an SSL connection allows you to securely transmit user credit card information to Stripe without storing it in your application, ensuring full PCI compliance. Piggyback SSL is available by default for apps on <code>subdomain.herokuapp.com</code>, or inexpensively via Heroku's wildcard SSL add-on.

_("Mazuma" is the Yiddish word for money.)_

Getting Started
---------------

    $ git clone git://github.com/worldlywisdom/mazuma.git

    $ gem install bundler

    $ bundle install

    $ git init .

    $ git commit -m "Initial commit"

    $ heroku create yourappname

    $ git push heroku master

Setting Global and Environment Variables
----------------------------------------

Global variables are set in the <code>/config/globals.rb</code> file. This file is read by both the Sinatra application and the Rakefile, ensuring these items are consistent and available across the application.

Once you've set up accounts at [Stripe](http://stripe.com) and [Mailgun](http://mailgun.net), you'll need to add your API keys to Heroku as environment variables. This help you keep your private keys secure if you contribute to open source or in the event your machine is compromised. (Be sure to replace "t0psecretkey" with your personal key.)

**Set Stripe.com Keys**

    $ heroku config:add STRIPE_SECRET_KEY=t0psecretkey

    $ heroku config:add STRIPE_PUBLISHABLE_KEY=publickey

**Set Mailgun.net Keys**

    $ heroku config:add MAILGUN_PRIVATE_KEY=t0psecretkey

Changing Page Copy & Design
---------------------------

All pages in this application are ERB templates, which can be found in the <code>/views</code> directory.

The general page layout is set in <code>/views/layout.erb</code>. The site uses [Bootstrap](http://getbootstrap.com/) as a design framework, modified by a custom stylesheet in <code>/public/css/stylesheet.css</code>. Fancy fonts are provided by [Google Web Fonts](http://www.google.com/webfonts), which are included in the header of <code>/views/layout.erb</code> and set in <code>/public/css/stylesheet.css</code>.

Notably, it's easy to change the default layout to a single-column format by removing the <code>sidebar</code> div in <code>/views/layout.erb</code> and changing the <code>container</code> div to <code>"span8 offset1"</code>

Sending Email Broadcasts
------------------------

The included Rakefile contains two Rake tasks that make it easy to send broadcast emails to your paid users. For security, broadcast emails to your users are sent via the command line vs. a web-based interface, since Heroku command line logins require both your SSH key file and password.

### Step 1: Upload Files

Add your email message to <code>/email/messages</code>, and upload the fie to Heroku by running <code>$ git push heroku master</code> after adding and committing the file to your repo. Text or HTML files are supported. I recommend using a <code>YEAR-MONTH-DAY-filename.extention</code> naming scheme to make your messages easy to find later.

Add file attachments to <code>/email/attachments</code>.

### Step 2: Preview Your Email

Use this command to send a preview email to the administrator email set in the <code>/config/globals.rb</code> file.

    $ heroku rake 'email:preview["Subject Line","2012-01-01-message.extention"]'

If you'd like to include an attachment, use this command:

    $ heroku rake 'email:preview["Subject Line","2012-01-01-message.extention","attachment.extention"]'

### Step 3: Send the Broadcast

Use this command to send a broadcast email to the Mailgun list set in the <code>/config/globals.rb</code> file.

    $ heroku rake 'email:broadcast["Subject Line","2012-01-01-message.extention"]'

If you'd like to include an attachment, use this command:

    $ heroku rake 'email:broadcast["Subject Line","2012-01-01-message.extention","attachment.extention"]'
    
These commands change to <code>$ heroku run rake</code> if you deploy to Heroku's Cedar stack.

Extending Mazuma
----------------

**You can extend the features of Mazuma however you desire.** Want to add your customers to a database? Integrate with other APIs? Change mailing or credit card services? Mazuma is simple enough to change: everything you need is in <code>application.rb</code> and <code>/modules/mailer.rb</code>.

Enjoy!