Rails.application.routes.draw do
  root 'stages#index'
  get 'bad_request' => 'stages#bad_request'
  get 'forbidden' => 'stages#forbidden'
  get 'internal_server_error' => 'stages#internal_server_error'

  resources :stages do
    get 'search', on: :collection
    collection do
      post :confirm
    end
    member do
      get :admin_stage_show
      get :actor_stage_show
    end
    resources :reservations
  end
  resource :actorsessions, only: %i[create destroy]
  resource :usersessions, only: %i[create destroy]
  resource :adminsessions, only: %i[create destroy]
  resource :password, only: %i[show edit update]

  resources :actors do
    collection do
      get :actor_false_stages
      get :actor_true_stages
    end
    # resources :stages
  end
  resources :users do
    resources :reservations
  end
  # resources :users
  resource :admin do
    collection do
      get :admin_false_stages
      get :admin_true_stages
    end
  end

end
