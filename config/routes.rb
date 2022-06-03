Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    resources :users, only: [:index, :show, :update]
    resources :posts, only: [:index, :show, :update] do
      resources :comments, only: [:index, :show, :update]
    end
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
    get '/search', to: "searches#search"
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      resource :relationship, only: [:create, :destroy]
    end
    
    resources :posts do
      resource :bookmark, only: [:create, :destroy]
    end
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
