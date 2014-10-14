Rails.application.routes.draw do

  # Api definition. /api/resource_name/...
  # Set responses to json
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
    	# get 'rate/calculate' => 'rate#calculate'
    	resources :user, except: [:new, :edit, :destroy]
  		resources :session, only: [:index, :create]
  		resources :rate, except: [:new, :edit] do
        collection do
          get 'calculate'
        end 
      end
      resources :agency, except: [:new, :edit]
      resources :package, except: [:new, :edit, :destroy]
    end
  end
end
