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
  end

end
