Rails.application.routes.draw do

  get "ping", to:"application#ping"

  namespace :v1, defaults: { format: :json } do
    resources :user, only: [] do
      collection do
        post 'sign_in'
        post 'refresh_token'
        post 'sign_out'
      end
    end
    
    resources :profile, only:[:index] do 
     
    end
    
    resources :patient, only:[:show] do 
      get 'patient_result', to:"patient#patient_result"
      get 'release_result/:patient_lab_id', to:"patient#release_result"
      get 'get_pdf/:patient_lab_id', to:"patient#get_pdf"
      get 'patient_lab_studies/:patient_lab_id', to:"patient#patient_lab_studies"
      get 'get_pdf/:patient_lab_id', to:"patient#get_pdf"
      get 'accept_connection', to:"patient#accept_connection"
      get 'reject_connection', to:"patient#reject_connection"
      collection do
        get 'search/:page/:name', to:"patient#search"
        get "list/:type/:page", to:'patient#list'
      end
    end
  end
end
