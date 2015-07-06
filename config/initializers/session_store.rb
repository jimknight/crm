# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_crm_session'

# http://stackoverflow.com/questions/19168178/rails-401-unauthorized-when-i-access-action-in-production-only
Rails.application.config.session_store :cookie_store, key: '_crm_session', domain: {
  production: 'crm.rossmixing.com'
}.fetch(Rails.env.to_sym, :all)