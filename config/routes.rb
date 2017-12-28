Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get 'verse/index'
    get '/quiz', to: 'verse#index'
    get '/logs', to: 'logs#index'
    get '/pushkin', to: 'verse#created_verse'
    post '/quiz', to: 'verse#v_post'
  root 'logs#index'
end
