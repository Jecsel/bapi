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

    resources :schedule, only:[:create] do 
      collection do 
        
      end
    end
    resources :clinic, only:[:create, :update, :destroy, :show] do 
      collection do 
      end
    end
    resources :location, only:[:create, :index, :update, :destroy, :show] do 
      get 'schedules' #, to:"location#schedules"
    end
  end

end
