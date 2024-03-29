Rails.application.routes.draw do

  get '/feriadesoftware' => redirect('http://feriadesoftware.cl')
  get '/informatica' => redirect('http://inf.utfsm.cl')
  get '/facebook' => redirect('https://www.facebook.com/Carryvent')
  get '/usm' => redirect('http://www.usm.cl')
  ActiveAdmin.routes(self)
  resources :rankings
  #comentarios
  resources :comments, :only =>[:create, :destroy]

  #activity
  resources :notifications
  get '/checkNewNotification' => "notifications#checking_new" , as: :checking_new

  #Rutas de eventos
  get '/eventos' => 'evento#eventos', as: :lista_eventos_user
  get '/evento/:id' => 'evento#show', as: :mostrar_evento
  get '/operario/list_eventos' => "evento#list_eventos", as: :list_eventos
  get '/operario/ruta_evento/:id' => "evento#ruta_evento", as: :ruta_evento

  #Pasajes
  get '/evento/:id/reserva' => "pasajes#reserva", as: :reserva_pasaje
  post '/evento/:id/reserva' => "pasajes#reserva_send", as: :crear_reserva
  get '/evento/:id/reservado' => "pasajes#reservado", as: :pasaje_reservado
  post '/reserva/concretar/:id' => "pasajes#aceptar_reserva", as: :concretar_reserva
  get '/operario/list_pasajes/:id' => "pasajes#list_pasajes", as: :list_pasajes


  #Ruta organizadores

  #Rutas de informacion de usuario
  get '/user/:id' => 'user#perfil', as: :perfil_user
  #testing
  get '/user/:id/editar' => 'user#editar', as: :editar_user

  #get '/user/:id/editarpasswd' => 'devise/passwords#edit',   :as => :edit_user_password
  #get '/user/:id/editarpasswd' => 'user#editarpasswd', as: :editarpasswd_user


  #Carpool
  get 'evento/:evento_id/carpool/publicar' => 'carpool#publicar', as: :publicar_carpool
  post 'evento/:evento_id/carpool/publicar' =>  'carpool#new', as: :new_publicar_carpool
  get 'evento/:evento_id/carpool/:id' => 'carpool#show', as: :mostrar_carpool
 
  post 'evento/:evento_id/carpool/:id' => 'carpool#new_transaction', as: :crear_transaccion_carpool
  get 'evento/carpool/:evento_id/:id/:transaction_id/accept' => 'carpool#aceptar_transaction', as: :aceptar_transaccion
  get 'evento/carpool/:evento_id/:id/:transaction_id/reject' => 'carpool#rechazar_transaction', as: :rechazar_transaccion
  get 'evento/carpool/:evento_id/:id/:transaction_id/delete' => 'carpool#delete_transaction' , as: :borrar_transaccion

  #match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  #Rutas para sobreescribir las rutas de devise
  devise_for :users,  :controllers => { :omniauth_callbacks => 'omniauth_callbacks', :registrations => "registrations"  }, :skip => [:sessions, :passwords, :confirmations, :registrations]
  as :user do
    #Registro
    get   '/registrarse' => 'registrations#new',    :as => :new_user_registration
    post  '/registrarse' => 'registrations#create', :as => :user_registration

    #Login
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    match 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session,
      :via => Devise.mappings[:user].sign_out_via

    scope '/account' do
      # password reset
      get   '/resetpassword'        => 'devise/passwords#new',    :as => :new_user_password
      put   '/resetpassword'        => 'devise/passwords#update', :as => :user_password
      post  '/resetpassword'        => 'devise/passwords#create'
      get   '/resetpassword/change' => 'devise/passwords#edit',   :as => :edit_user_password

      # confirmation
      get   '/confirm'        => 'devise/confirmations#show',   :as => :user_confirmation
      post  '/confirm'        => 'devise/confirmations#create'
      get   '/confirm/resend' => 'devise/confirmations#new',    :as => :new_usern_confirmation

      # settings & cancellation
      get '/cancel'   => 'registrations#cancel', :as => :cancel_user_registration
      get '/settings' => 'registrations#edit',   :as => :edit_user_registration
      post '/settings' => 'registrations#update', :as => :update_user_registration

      # account deletion
      delete '' => 'devise/registrations#destroy'
    end
    ## Mas rutas http://iampedantic.com/post/41170460234/fully-customizing-devise-routes
  end

  #Lo mismo de lo anterior pero para publicadores
  devise_for :publicadors, :skip => [:sessions, :passwords, :confirmations, :registrations]
  as :publicador do
    get 'cv-login' => 'devise/sessions#new', :as => :new_publicador_session
    post 'cv-login' => 'devise/sessions#create', :as => :publicador_session
    match 'cv-logout' => 'devise/sessions#destroy', :as => :destroy_publicador_session,
      :via => Devise.mappings[:publicador].sign_out_via
  end

  #resource :user, only: [:edit] do
  #  collection do
  #    patch 'update_password'
  #  end
  #end

  authenticated :user do
    root :to => "evento#eventos", as: "authenticated_root"
  end

  authenticated :publicador do
    root :to => "admin/dashboard#index", as: "authenticated_publicador_root"
  end

  root :to => 'index#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
