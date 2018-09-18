Rails.application.routes.draw do
  get '/server_timestamp', to: 'server_timestamp#show'

  post '/client_event_proxy', to: 'client_event_proxy#create'

  resources :todos, only: %i[index show new create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "todos#index"
end
