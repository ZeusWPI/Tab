Airbrake.configure do |config|
  config.api_key = '066f6146dde14038b5ab69a2f680cd4a'
  config.host    = 'zeus-errbit.ilion.me'
  config.port    = 80
  config.secure  = config.port == 443
end
