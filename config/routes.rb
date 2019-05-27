Rails.application.routes.draw do


  # scope '', controller: 'web/user' do
  #   get '/login' => :login
  # end

  match '/', to: 'application#not_found', via: :all
  match '*permalink', to: 'application#not_found', via: :all

end