Rails.application.routes.draw do

  # Api definition. /api/resource_name/...
  # Set responses to json
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :user
      resources :session
    end
  end
end
