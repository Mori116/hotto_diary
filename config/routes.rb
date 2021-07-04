Rails.application.routes.draw do
  devise_for :users
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  root to: 'homes#top'
  get 'homes/about' => "homes#about"

  resouces :users, only: [:show, :edit, :update] do
    member do
    get 'quit'
    patch 'withdraw'
    end
  end

  resouces :diaries do
    resouces :diary_comments, only: [:create, :destroy]
  end

  resouces :groups do
    member do
    get 'join'
    end
  end

  get '/search' => "search#search"

  namespace :admin do
    resouces :news, only: [:new, :create, :edit, :update]
    resouces :users, only: [:index, :show, :edit, :update]
    resouces :diaries, only: [:index, :show, :edit, :update, :destroy]
    resouces :groups, only: [:index, :show, :edit, :update, :destroy]
    get '/search' => "search#search"
  end

end
