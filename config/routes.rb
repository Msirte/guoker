Rails.application.routes.draw do

  get 'notices/index'
  get 'notices/show'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'

  resources :notices

  resources :courses do
    member do
      get :select
      get :quit
      get :open
      get :close
      get :timetable
    end
    collection do
      get :list
      post :list
    end
    
    # collection do
    #   get :my_course_list
    #   post :my_course_list
    #   post :save_discuss
    #   post :select
    # end
  end

  resources :grades, only: [:index, :update]
  resources :users

  get 'sessions/login' => 'sessions#new'
  post 'sessions/login' => 'sessions#create'
  delete 'sessions/logout' => 'sessions#destroy'

end