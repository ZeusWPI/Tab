# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_Tab_session'
Rails.application.config.session_store :cookie_store, expire_after: 31.days
