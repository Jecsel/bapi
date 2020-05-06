Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sys-log'
  
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
          get 'status', to:'payment#status'
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
    resources :setting, only:[:index] do 
      collection do 
        patch 'update'
      end
    end
    resources :booking, only:[:index, :show] do 
      collection do 
        post 'filter'
        
        post 'cancel_booking'
        post 'mark_no_show'
        post 'mark_as_completed'
        post 'edit_booking'
        post 'paginate'
        post 'search'
        post 'filter_status'
        post 'filter_date'
        post 'filter_booking'
      end
    end
    resources :user, only: [:index] do
      collection do
        post 'sign_in'
        post 'authenticate'
        post 'get_policies'
        post 'sign_out'
      end
    end

    resources :schedule, only:[:create, :show] do 
      get 'slot/:slot_id', to:"schedule#slot"
      post 'close_slot/:slot_id', to:"schedule#close_slot"
      collection do 
        
      end
    end
    resources :clinic, only:[:create, :index, :update, :destroy, :show] do 
      collection do 
      end
    end
    resources :location, only:[:create, :index, :update, :destroy, :show] do 
      get 'schedules'
      get 'clinics'
      post 'add_clinic', to:"location#add_clinic"
    end
  end

end
