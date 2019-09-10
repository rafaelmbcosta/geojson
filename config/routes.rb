Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :feature_collections
  resources :coordinates
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/areas' => 'feature_collections#areas'
  post '/inside' => 'coordinates#inside', as: :inside
  root :to => 'feature_collections#areas'
end
