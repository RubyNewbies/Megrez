Megrez::Application.routes.draw do

  get 'nodes/new'

  get 'nodes/show'

  get 'nodes/edit'

  get 'nodes/destroy'

  root 'static_pages#home'

  get '/me', controller: 'users', action: 'me'

  get '/dashboard', controller: 'users', action: 'dashboard'

  get  '/signup', controller: 'users', action: 'new'
  post '/signup', controller: 'users', action: 'create'

  get  '/login', controller: 'sessions', action: 'new'
  post '/login', controller: 'sessions', action: 'create'

  delete '/logout', controller: 'sessions', action: 'destroy'

  resources :users
  resources :courses 

  resources :courses do
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

end
