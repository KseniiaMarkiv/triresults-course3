Rails.application.routes.draw do
  # root "races#index"
  # resources :races

  resources :racers do
    post "entries" => "racers#create_entry"
  end
  resources :races
### this is comands need to get all routes in api ### but not suitable for solution

  namespace :api, defaults: {format: 'json'} do
    resources :racers do
      resources :entries, only: [:index, :show]
    end
    resources :races do
      resources :results, only: [:index, :show, :update]
    end
  end 

  # • /api/races - to represent the collection of races
  # • /api/races/:id - to represent a specific race
  # • /api/races/:race_id/results - to represent all results for the specific race
  # • /api/races/:race_id/results/:id - to represent a specific results for the specific race
  # • /api/racers - to represent the collection of racers
  # • /api/racers/:id - to represent a specific racer
  # • /api/racers/:racer_id/entries - to represent a the collection of race entries for a specific racer
  # • /api/racers/:racer_id/entries/:id - to represent a specific race entry for a specific racer


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
