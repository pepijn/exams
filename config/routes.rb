Exams::Application.routes.draw do
  resources :questions, only: [:index, :show] do
    resource :answer, only: :new
  end

  resources :answers, only: :create

  resources :exams do
    resource :session, only: :create
  end

  root 'exams#index'
  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
end

