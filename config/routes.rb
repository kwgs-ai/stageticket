Rails.application.routes.draw do
  root 'stages#index'
  resources :stages do
    get 'search', on: :collection
  end
  resource :actorsession, only: [:create, :destroy]
  resources :actoraccounts do
  end
end
