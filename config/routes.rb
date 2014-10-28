Megrez::Application.routes.draw do

  root 'static_pages#home'

  get '/me', controller: 'users', action: 'me'

  get '/center', controller: 'users', action: 'center', as: :user_center

  get  '/signup', controller: 'users', action: 'new'
  post '/signup', controller: 'users', action: 'create'

  get  '/login', controller: 'sessions', action: 'new'
  post '/login', controller: 'sessions', action: 'create'

  delete '/logout', controller: 'sessions', action: 'destroy'

  resources :users
  resources :courses

  resources :courses do
    member do
      get 'docs', as: :docs
      get 'assmt', as: :assmt
      get 'forum', as: :forun
      get 'members', as: :members
      get 'admin', as: :admin
    end
  end

end
