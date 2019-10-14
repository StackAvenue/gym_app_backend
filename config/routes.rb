Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations },
                       path_names: { registration: :sign_up }

    resources :users, only: [:show, :update, :index, :destroy] do
      resources :user_details
    end
    resources :user_details
  end
end
