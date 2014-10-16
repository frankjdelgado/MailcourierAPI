Apipie.configure do |config|
  config.app_name                = "Mailcourier API"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "**","*.rb")
  config.api_routes = Rails.application.routes
  config.validate = false
end
