# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_image-editor_session',
  :secret => 'f5f2cd258c8431d28376667e442922e754eb63f3df2be2fc1cf73ef1cd0a4ec7f0f24efeda5fbfb886974a553ff444c1a9908304e9914e1f1b67c4cc64606b0c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
