Rails.application.routes.draw do
  root 'stages#index'

  resources :stages do
    get 'search', on: :collection
    collection do
      post :confirm
    end
    resources :reservations
  end
  resource :actorsessions, only: [:create, :destroy]
  resource :usersessions, only: [:create, :destroy]
  resource :adminsessions, only: [:create, :destroy]

  resources :actoraccounts do
    resources :stages, only: [:index]
  end
  resources :useraccounts do
    resources :reservations
  end
  resources :useraccounts
  resources :actoraccounts
  resources :adminaccounts do
    resources :stages
  end

end
