Rails.application.routes.draw do


  get "ping", to:"application#ping"

  #BOOKING
  namespace :v1, defaults: { format: :json } do
    namespace :guest do 
      resources :location, only:[:index] do 
        get 'schedules', to:"location#schedules"
      end
      resources :booking, only:[:create] do 
        
      end
    end
  end


  #ADMIN
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
    resources :clinic, only:[:create, :index, :update, :destroy, :show] do 
      collection do 
      end
    end
    resources :location, only:[:create, :index, :update, :destroy, :show] do 
      get 'schedules' #, to:"location#schedules"
    end
  end

end
