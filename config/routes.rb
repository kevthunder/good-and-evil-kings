GoodAndEvilKings::Application.routes.draw do

  resources :diplomacies, only: [:index, :show]

  resources :ais

  resources :options

  resources :modificators
  
  namespace :admin do
    resources :ai_actions
    resources :building_types
    resources :mission_types
    resources :mission_lengths
    resources :mission_statuses
    resources :name_fragments
    resources :ressources
    resources :soldier_types
  end
  resources :buildings
  get 'buildings/:id/upgrade' => 'buildings#upgrade', as: 'upgrade_building'
  post 'buildings/:id/upgrade' => 'buildings#upgrade_now'


  resources :missions do
    resources :missions, only: [:new, :create]
  end
  get 'missions/:id/redeem' => 'missions#redeem'

  resources :movements

  resources :garrisons, except: [:index]
  get ':type/:id/garrisons' => 'garrisons#index', as: 'garrisons_for'

  resources :stocks


  resources :kingdoms

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'tiles#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  get 'tiles/list' => 'tiles#list'
  post 'tiles/partial' => 'tiles#partial'
  resources :tiles
  resources :castles do
    resources :missions, only: [:new, :create]
    resources :garrisons, only: [:new, :create]
  end

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
