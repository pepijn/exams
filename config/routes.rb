Exams::Application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :questions, only: [:index, :show] do
    resource :answer, only: :new
    resources :alerts, only: :create
  end

  # TODO: remove this line
  resources :answers

  resources :answers, only: :create

  resources :courses do
    resources :exams
    resources :questions
  end

  resources :levels do
    resources :questions
    resource :session
  end

  resources :exams do
    resource :session, only: :create
    resources :questions, only: :new
  end

  resources :orders
  resource :payment

  resource :session, only: [:create, :destroy]
  resources :sessions, only: :show

  resources :questions, only: [:create, :destroy]

  root 'levels#index'
end

