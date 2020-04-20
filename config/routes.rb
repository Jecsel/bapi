Rails.application.routes.draw do


  get "ping", to:"application#ping"

  namespace :v1, defaults: { format: :json } do
    resources :user, only: [] do
      collection do
        post 'sign_in'
        post 'authenticate'
        post 'sign_out'
      end
    end

    resource :schedule, only:[:create] do 
      collection do 
        
      end
    end
    resources :location, only:[:create, :index, :update, :destroy, :show] do 
      collection do 

      end
    end
  end

end
