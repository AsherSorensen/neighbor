Rails.application.routes.draw do
  get "/health", to: "health#check"
  post "/", to: "search#search"
end
