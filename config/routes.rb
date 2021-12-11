Rails.application.routes.draw do
  root 'stages#index'
  resources :stages do
    get 'search', on: :collection
  end
end
