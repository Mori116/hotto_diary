Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

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
        get 'join_groups'
      end
    end

    resources :groups do
      resources :diaries do
        resources :diary_comments, only: [:create, :destroy]
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
    resources :users, only: [:index, :show, :edit, :update]

    resources :groups, only: [:index, :show, :destroy] do
      collection do
        get 'diaries'
      end
      resources :diaries, only: [:index, :show, :destroy]
    end

    get 'search' => "searches#search"
  end

end
