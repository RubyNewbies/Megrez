Megrez::Application.routes.draw do

  root 'static_pages#home'

  get '/me', controller: 'users', action: 'me'

  get  '/signup', controller: 'users', action: 'new'
  post '/signup', controller: 'users', action: 'create'

  get  '/login', controller: 'sessions', action: 'new'
  post '/login', controller: 'sessions', action: 'create'

  delete '/logout', controller: 'sessions', action: 'destroy'

  resources :users

end
