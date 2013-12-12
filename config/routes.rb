Exams::Application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :questions, only: [:index, :show] do
    resource :answer, only: :new
  end

  resources :answers, only: :create

  resources :courses do
    resources :exams
    resources :questions
  end

  resources :exams do
    resource :session, only: :create
    resources :questions, only: :new
  end

  resources :orders
  resource :payment

  resource :session, only: [:create, :destroy]

  resources :questions, only: :create

  root 'exams#index'
end

