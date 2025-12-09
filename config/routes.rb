Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "flyers#index"

  resources :flyers
  resources :bands
  resources :venues

  namespace :api do
    resources :bands, only: [ :index ]
    resources :venues, only: [ :index ]
    get :search, to: "search#index"
  end
end
