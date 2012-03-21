Sitemessage::Application.routes.draw do
  resources :short_messages do
    collection do
      get 'exchange'
    end
  end
  
  resources :short_messages
  
  # -- 用户登录认证相关 --
  root :to => 'index#index'
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'
end
