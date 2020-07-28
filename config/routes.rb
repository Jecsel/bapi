Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sys-log'
  
  root :to => 'home#index'

  get "ping", to:"application#ping"

  #BOOKING
  namespace :v1 do
    namespace :guest do 
      resources :location, only:[:index] do 
        get 'areas', to:"location#areas"
        get 'schedules', to:"location#schedules"
        get 'web_schedules', to:"location#web_schedules"
        get 'find_schedules/:scheduled_id', to:"location#find_schedules"
        collection do
          post 'clinic_area'
        end
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
    resources :payment_mode, only:[:index] do 
    end
    resources :dashboard do 
      collection do 
        get 'booking_graph'
      end
    end
    resources :clinic_area, only:[:create, :index] do 
      collection do 
        
      end
    end
    resources :setting, only:[:index] do 
      collection do 
        patch 'update'
        get 'get_price'
      end
    end
    
    resources :booking, only:[:index, :show] do 
      collection do 
        get  'search/:search_str', to:"booking#search"
        post 'filter'
        post 'export'
        post 'cancel_booking'
        post 'mark_no_show'
        post 'mark_as_completed'
        post 'edit_booking'
        post 'upload_document'
        post 'download_document'
        post 'confirm_manual_payment', to:'booking#confirm_manual_payment'
        # post 'paginate'
        # post 'filter_status'
        # post 'filter_date'
        # post 'filter_booking'
      end
    end
    resources :user, only: [:index, :create] do
      collection do
        post 'sign_in'
        post 'authenticate'
        post 'get_policies'
        post 'sign_out'
        post 'edit_user'
        post 'update_pass'
      end
    end

    resources :schedule, only:[:create, :show, :destroy] do 
      get 'slot/:slot_id', to:"schedule#slot"
      post 'close_slot/:slot_id', to:"schedule#close_slot"
      collection do 
        
      end
    end
    resources :clinic, only:[:create, :index, :update, :destroy, :show] do 
      collection do 
        get 'list'
        post 'paginate'
        post 'filter'
      end
    end
    resources :location, only:[:create, :index, :update, :destroy, :show] do 
      collection do   
        post 'filter'
        post 'paginate'
      end
      get 'get_schedules', to:"location#get_schedules"
      get 'find_schedules/:scheduled_id', to:"location#find_schedules"
      get 'schedules/:page', to:"location#schedules"
      get 'clinics'
      post 'add_clinic', to:"location#add_clinic"
      post 'unlink_clinic', to:"location#unlink_clinic"
    end
    resources :audit, only:[:index] do 
      collection do   
        post 'filter'
        post 'export'
      end
    end
    resources :campaign, only:[:index, :create, :update, :show] do 
      collection do   
        post 'filter'
        post 'upload_participant'
        post 'delete_participant'
        post 'paginate_participant'
        post 'generate_request_forms'
        post 'add_campaign_client'
        post 'add_campaign_company'
        post 'add_campaign_billing'
        post 'add_campaign_doctor'
        post 'add_campaign_incharge'
        get 'campaign_client'
        get 'campaign_company'
        get 'campaign_billing'
        get 'campaign_doctor'
        get 'campaign_incharge'
      end
    end
  end

end
