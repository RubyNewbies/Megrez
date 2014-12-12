Megrez::Application.routes.draw do

  root 'static_pages#home'

  get '/me', controller: 'users', action: 'me'
  get '/file_exists', :to => 'files#exists'
  get '/dashboard', controller: 'users', action: 'dashboard'

  get  '/signup', controller: 'users', action: 'new'
  post '/signup', controller: 'users', action: 'create'

  get  '/login', controller: 'sessions', action: 'new'
  post '/login', controller: 'sessions', action: 'create'

  delete '/logout', controller: 'sessions', action: 'destroy'

  #get  '/folders', controller: 'folders', action: 'index'

  resources :users
  
  resources :courses do

    resources :nodes, path: '/forum/nodes'
    resources :topics, path: '/forum/topics'

    member do
      get 'home', as: :home
      get 'docs', as: :docs
      get 'assmt', as: :assmt
      get 'forum', as: :forum
      get 'members', as: :members
      get 'admin', as: :admin
      get 'wiki', as: :wiki
      
      post 'join', as: :join
      delete 'leave', as: :leave
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
