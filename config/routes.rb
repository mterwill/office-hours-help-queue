Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  root 'landing#index'

  resources :course_queues, only: [:show]
end
