# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_image-editor_session',
  :secret      => '3e64ce5f522acd0e3abd87f6cd9f7beeb5a4ea2bc63bbd3be85f0648c8021ae00487fdeaeb64b54f2f9d2b3d9de20b2ca4f04cbb5b5c94eac51f67c60d95c8e8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
