Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get "users/:id/confirm" => "users#confirm", as: "user_confirm"
    patch "users/:id/deactivate" => "users#deactivate", as: "user_deactivate"
    resources :users, only: [:index, :show, :update]
    resources :posts, only: [:index, :show, :update] do
      resources :comments, only: [:show, :update]
    end
    get "reports/pending"
    resources :reports, only: [:index, :show, :update]
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
    resources :searches, only: [:new]

    get "users/:id/posts" => "users#posts", as: "user_posts"
    get "users/:id/welcome" => "users#welcome", as: "user_welcome"
    get "users/:id/confirm" => "users#confirm", as: "user_confirm"
    get "users/:id/by_category" => "users#by_category", as: "user_posts_by_category"
    patch "users/:id/withdraw" => "users#withdraw", as: "user_withdraw"
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      resource :relationship, only: [:create, :destroy]
      get "friends" => "relationships#friends", as: "friends"
      get "followers" => "relationships#followers", as: "followers"
      get "following" => "relationships#following", as: "following"
    end

    get "/bookmarks" => "bookmarks#index"

    get "posts/drafts"
    get "posts/by_category"
    resources :posts do
      resource :bookmark, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end

    resources :rooms, only: [:create, :show, :index]
    resources :messages, only: [:create]
    get "reports/en/new" => "reports#new_en", as: "new_report_en"
    resources :reports, only: [:new, :create, :show]
    patch "notifications/destroy_all"
    resources :notifications, only: [:index, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
