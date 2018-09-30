Rails.application.routes.draw do
  resources :todos, only: %i[index show new create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "todos#index"
end
