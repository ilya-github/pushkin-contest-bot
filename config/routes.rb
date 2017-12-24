Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get 'verse/index'
    get '/quiz', to: 'verse#index'
    post '/quiz', to: 'verse#v_post'
  root 'verse#created_verse'
end
