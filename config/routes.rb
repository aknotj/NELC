Rails.application.routes.draw do

  namespace :public do
    get 'home/top'
    get 'home/home'
  end
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }
  
  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  
  scope module: :public do
    root to: "home#top"
    get "/home", to: "home#home"
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
