Rails.application.routes.draw do

  resources :games
  resources :emails
  resources :boards
  root 'emails#new'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
