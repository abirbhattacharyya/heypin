# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_heypin_session',
  :secret      => 'e59fc32589671d90d6919f793367914be976a2b8c82775b96fab255ccacb8e2f723665158b594bf7abc9107c7a9d63cc5d9a0695cee4ad58235517bcf0109d9b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
