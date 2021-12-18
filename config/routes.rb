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

  resources :actors do
    collection do
      get :actor_false_stages
      get :actor_true_stages
    end
    member do
      get :actor_stage_show
    end
  end
  resources :users do
    resources :reservations
  end
  resources :users

  resources :admin do
    resources :stages
    collection do
      get :admin_false_stages
      get :admin_true_stages
    end
    member do
      get :admin_stage_show
    end
  end

end
