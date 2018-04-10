Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  devise_for :admins, ActiveAdmin::Devise.config

  resources :sensors do
    get :visualisation, :on=>:collection
  end

  resources :locations

  #resources :home
  get 'api' => 'api#show'


  resources :community

  resources :visualisation

  mount Thredded::Engine => '/forum'

  # below code to fix the active admin issue when table not exists in database as activeadmin tries to load every model.
  # for reference https://github.com/activeadmin/activeadmin/issues/783
  begin
    ActiveAdmin.routes(self)
  rescue Exception => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end
  root :to => redirect("/DatenFuerDieStadt/index.html")

end
