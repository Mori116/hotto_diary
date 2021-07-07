Rails.application.routes.draw do

  devise_for :users
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

# ユーザ側
scope module: :public do
  root to: 'homes#top'
  get 'homes/about' => "homes#about"

  resources :users, only: [:show, :edit, :update] do
    member do
    get 'quit'
    patch 'withdraw'
    end
  end

  resources :groups do
    resources :diaries do
      resources :diary_comments, only: [:create, :destroy]
    end
    collection do
      get 'join_groups'
    end
    member do
      get 'join'
      post 'join_create'
      delete 'exit'
    end
  end

  get 'search' => "searches#search"

end

# 管理者側
  namespace :admin do
    resources :news, only: [:new, :create, :edit, :update, :destroy]
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get 'join_groups'
      end
    end

    resources :groups, only: [:index, :show, :edit, :update, :destroy] do
     resources :diaries, only: [:index, :show, :edit, :update, :destroy]
    end

    get 'search' => "searches#search"
  end

end
