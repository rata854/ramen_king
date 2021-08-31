Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  root to: 'homes#top'
  get 'about' => 'homes#about'
  resources :stores, except: [:destroy] do
    resources :store_comments, except: [:index] do
      resource :favorites, only: [:create, :destroy]
    end
  end
  resources :users, only: [:show, :edit, :update, :destroy]
  get 'search' => 'stores#search'
end
