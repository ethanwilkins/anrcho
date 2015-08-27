Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'proposals#index'
  
  # proposals
  get 'proposals/:id/votes/up_vote', to: 'proposals#up_vote', as: 'up_vote'
  get 'proposals/:id/votes/down_vote', to: 'proposals#down_vote', as: 'down_vote'
  get 'proposals/add_image', as: 'add_proposal_image'
  get 'proposals/switch_section/:section', to: 'proposals#switch_section', as: 'switch_section'
  post 'proposals/create', as: 'create_proposal'
  
  # search
  get 'search', to: 'search#index', as: 'search'
  get 'search/new', to: 'search#new', as: 'new_search'
  get 'search/toggle_menu', as: 'toggle_menu'
  
  # tokens
  get 'token/update', as: 'update_token'
  get 'token', to: 'token#index', as: 'token'
  
  # pages
  get 'pages/more', as: 'more'
  get 'fib', to: 'pages#fib', as: 'fib'
  
  # manifestos
  get 'manifestos/toggle_manifesto', as: 'toggle_manifesto'
  
  # messages
  post 'messages/create', as: 'messages'
  get 'messages/instant_messages', to: 'messages#instant_messages'
  get 'groups/:token/chat', to: 'messages#index', as: 'chat'
  post 'messages/new_chat', as: 'new_chat'
  get 'messages/add_image', as: 'add_message_image'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :groups
  resources :manifestos
  resources :proposals do
    resources :comments do
      resources :votes
    end
    resources :votes
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
