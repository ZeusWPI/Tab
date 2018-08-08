if Rails.env.production?
  Rails.application.config.middleware.delete(Rack::Runtime)
end
