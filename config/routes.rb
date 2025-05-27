Rails.application.routes.draw do
  get '/health', to: 'health#check'

  # Defines the root path route ("/")
  # root "posts#index"
end
