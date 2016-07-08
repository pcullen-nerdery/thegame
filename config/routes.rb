Rails.application.routes.draw do
  namespace :admin do
    resources :effects
    resources :items do
      post 'use', on: :member
      post 'queue', on: :member
    end

    resources :queued_items

    root to: "items#index"
  end
end
