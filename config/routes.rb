Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'about' => 'homes#about'
  resources :stores do
    resources :store_comments, except: [:index]
  end
  
end
