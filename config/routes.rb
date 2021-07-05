Rails.application.routes.draw do

  devise_for :users
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

# user側
scope module: :public do
  root to: 'homes#top'
  get 'homes/about' => "homes#about"

  resources :users, only: [:show, :edit, :update] do
    member do
    get 'quit'
    patch 'withdraw'
    end
  end

  resources :diaries do
    resources :diary_comments, only: [:create, :destroy]
  end

  resources :groups do
    collection do
      get 'join_groups'
    end
    member do
      get 'join'
    end
  end

  get '/search' => "search#search"

end

# 管理者側
  namespace :admin do
    resources :news, only: [:new, :create, :edit, :update]
    resources :users, only: [:index, :show, :edit, :update]
    resources :diaries, only: [:index, :show, :edit, :update, :destroy]
    resources :groups, only: [:index, :show, :edit, :update, :destroy]
    get '/search' => "search#search"
  end

end
