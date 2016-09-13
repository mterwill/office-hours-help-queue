Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')

  root to: redirect('/courses')

  resources :courses, only: [:index, :show]

  namespace :admin do
    resources :course_queues, except: [:new, :show]
    resources :course_instructors, except: [:new, :show]

    resources :courses do
      member do
        resources :course_queues, only: [:new]
        resources :course_instructors, only: [:new]
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
