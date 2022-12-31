Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :places, only: [:index, :show]

  #get 'kaikki_bisset', to: 'beers#index'
  #get 'ratings', to:'ratings#index'
  #get 'ratings/new', to:'ratings#new'
  # post 'ratings', to: 'ratings#create'

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'places', to: 'places#index'
  post 'places', to: 'places#search'
  delete 'signout', to: 'sessions#destroy'

  resources :ratings, only: [:index, :new, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :session, only: [:new, :create, :destroy]
  # Defines the root path route ("/")
  # root "articles#index"
  root 'breweries#index'
end
