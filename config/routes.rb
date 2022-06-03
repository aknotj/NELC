Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }
  
  namespace :admin do
    resources :users, only: [:index, :show, ]
  end
  
  

  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in' => "public/sessions#new_guest"
  end

  scope module: :public do
    root to: "home#top"
    get "/home", to: "home#home"
    resources :users, only: [:index, :show, :edit, :update, :destroy]

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
