Rails.application.routes.draw do
  root 'stages#index'

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
  resource :actorsessions, only: [:create, :destroy]
  resource :usersessions, only: [:create, :destroy]
  resource :adminsessions, only: [:create, :destroy]

  resources :actors do
    collection do
      get :actor_false_stages
      get :actor_true_stages
    end
  end
  resources :users do
    resources :reservations
  end
  resources :users
  resource :admin do

      collection do
        get :admin_false_stages
        get :admin_true_stages
      end

  end


end
