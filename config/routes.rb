Rails.application.routes.draw do
  namespace :admin do
    resources :effects
    resources :items

    root to: "effects#index"
  end
end
