Rs::Application.routes.draw do
  resources :events, only: [:show]

  match 'carpool/login/:id' => 'events#login', via: [:get]
end
