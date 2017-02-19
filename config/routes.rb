Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')

  get '/heartbeat', to: 'heartbeat#index'

  root to: redirect('/courses')

  get '/courses/archive', to: 'courses#archive'

  resources :courses, only: [:index, :show]

  namespace :admin do
    resources :course_queues, except: [:new, :show]
    resources :course_instructors, except: [:new, :show]

    resources :courses do
      member do
        get :statistics
        resources :course_queues, only: [:new]
        resources :course_instructors, only: [:new] do
          get :promote, on: :collection
          post :promote, on: :collection
        end
      end
    end
  end

  resources :course_queues, only: [:show] do
    member do
      get 'outstanding_requests'
      get 'online_instructors'
    end
  end

  mount ActionCable.server => '/cable'
end
