Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'about' => 'homes#about'
  resources :stores, except: [:destroy] do
    resources :store_comments, except: [:index]
  end
  resources :users, only: [:show, :edit, :update]
  get 'search' => 'stores#search'
end
