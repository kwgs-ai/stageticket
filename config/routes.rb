Rails.application.routes.draw do
  root 'stages#index'
  resources :stages do
    get 'search', on: :collection
    collection do
      post :confirm
    end
  end
  resource :actorsession, only: [:create, :destroy]
  resources :actoraccounts do
  end

end
