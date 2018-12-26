# Be sure to restart your server when you modify this file.

# http://stackoverflow.com/questions/19168178/rails-401-unauthorized-when-i-access-action-in-production-only
Rails.application.config.session_store :cookie_store,
  key: '_crm_session',
  expire_after: 30.minutes,
  domain: {production: 'crm.rossmixing.com'}.fetch(Rails.env.to_sym, :all)
