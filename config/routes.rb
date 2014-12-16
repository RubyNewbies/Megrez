Megrez::Application.routes.draw do

  mathjax 'mathjax'

  root 'static_pages#home'

  get '/u/:username', controller: 'users', action: 'profile', as: :profile

  get '/me', controller: 'users', action: 'me'
  get '/file_exists', :to => 'files#exists'
  get '/dashboard', controller: 'users', action: 'dashboard'

  get  '/signup', controller: 'users', action: 'new'
  post '/signup', controller: 'users', action: 'create'

  get  '/login', controller: 'sessions', action: 'new'
  post '/login', controller: 'sessions', action: 'create'

  delete '/logout', controller: 'sessions', action: 'destroy'

  resources :activities
  resources :users
  resources :values
  resources :assignfiles
  resources :replies
  resources :notifications do
    collection do
      get 'mark_all', controller: 'notifications', action: 'mark_all'
    end
    member do
      get 'go', controller: 'notifications', action: 'go'
      get 'ignore', controller: 'notifications', action: 'ignore'
    end
  end

  resources :courses do

    resources :nodes, path: '/forum/nodes'
    resources :topics, path: '/forum/topics' do
      member do 
        post  'new_replies', controller: 'replies', action: 'create'
        #get   'edit_reply?repliy_id=:reply_id', controller: 'replies', action: 'edit', as: :edit_reply
        #patch 'reply?reply_id=:reply_id', controller: 'replies', action: 'update', as: :update_reply
      end
    end

    resources :assignments do
      member do
        get 'submit'
        post 'upload'
      end
    end

    resources :items, path: '/admin/items'

    member do
      get 'home', as: :home
      get 'docs', as: :docs
      get 'assmt', as: :assmt
      get 'forum', as: :forum
      get 'members', as: :members
      get 'admin', as: :admin
      get 'wiki', as: :wiki
      get 'grade', path: '/admin/grade'
      get 'final', path: '/admin/final'
      post 'join', as: :join
      delete 'leave', as: :leave
      get 'grade', controller: 'users', path: '/admin/grade/:user_id'
    end
  end

  resources :clipboard, :only => [:create, :destroy] do
    post :copy, :on => :member
    post :move, :on => :member
    put :reset, :on => :member
  end

  resources :files, :except => [:index, :new, :create]
  resources :permissions, :only => :update_multiple do
    put :update_multiple, :on => :collection
  end


  resources :folders, :shallow => true, :except => [:new, :create] do
    resources :folders, :only => [:new, :create]
    resources :files, :only => [:new, :create]
  end

  resources :folders do
    collection do
      delete :destroy_multiple
    end
  end

  resources :files do
    collection do
      post :operation_multiple
    end
    member do
      get :preview
    end
  end

  resources :files, :shallow => :true, :only => :show do
    resources :share_links, :only => [:new, :create]
  end
end
