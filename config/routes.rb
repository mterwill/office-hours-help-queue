Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')

  root 'landing#index'

  resources :course_queues, only: [:show] do
    member do
      get 'outstanding_requests'
      get 'online_instructors'
    end
  end

  mount ActionCable.server => '/cable'
end
