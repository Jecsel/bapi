Rails.application.routes.draw do
  root :to => 'home#index'

  get "ping", to:"application#ping"

  #BOOKING
  namespace :v1 do
    namespace :guest do 
      resources :location, only:[:index] do 
        get 'clinics', to:"location#clinics"
        get 'schedules', to:"location#schedules"
        get 'find_schedules/:scheduled_id', to:"location#find_schedules"
      end
      resources :payment, only:[] do 
        collection do
          post 'status', to:'payment#status'
          post 'confirmation', to:'payment#confirmation'
        end
      end
      resources :booking, only:[:create, :index] do 
        collection do
          post 'payment_confirmation', to:'booking#payment_confirmation'
        end
      end
    end
  end


  #ADMIN
  namespace :v1, defaults: { format: :json } do
    resources :booking, only:[:index] do 
      collection do 
        
      end
    end
    resources :user, only: [] do
      collection do
        post 'sign_in'
        post 'authenticate'
        post 'sign_out'
      end
    end

    resources :schedule, only:[:create, :show] do 
      collection do 
        
      end
    end
    resources :clinic, only:[:create, :index, :update, :destroy, :show] do 
      collection do 
      end
    end
    resources :location, only:[:create, :index, :update, :destroy, :show] do 
      get 'schedules' #, to:"location#schedules"
      get 'location_clinics'
      collection do
        post 'add_location_clinic'
      end
    end
  end

end
