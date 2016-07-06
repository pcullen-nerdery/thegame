Rails.application.routes.draw do
  namespace :admin do
    resources :effects
    resources :items do
      post 'use', on: :member
    end

    root to: "items#index"
  end
end
