# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

FB_APP_ID = "6ad71e73a2ae8f28b18f575b3ce3f185"
FB_APP_KEY = "25936306b718161e78f87a045c2aa7b8"
FB_APP_URL = "http://apps.facebook.com/newrailsapp/"
