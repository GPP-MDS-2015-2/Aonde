Rails.application.routes.draw do
  root 'welcome#index'
  get "welcome/index" => "welcome#index"
  
  get "public_agency/list" => "public_agency#index"
  
  get "public_agency/:id", to: "public_agency#show", as: 'public_agency'
  get "public_agency/:id/list_chart" ,to: "public_agency#filter_chart", as: "filter"
  get "public_agency/:id/type_expense",to: "type_expense#show", as: "type_expense"
  get "public_agency/:id/filter_type_expense",to: "type_expense#filter_chart", as: "filter_type_expense"
  get "public_agency/:id/company", to: "company#show", as: "company"
  get 'public_agency/:id/budgets', to: "budget#show", as: "budget"
  get "public_agency/:id/programs", to: "program#show", as: "programs"
  get "public_agency/:id/filter_budget",to: "budget#filter_chart_budget", as: "filter_budget"
  get "search/list", to:"search#index", as: "search"
  #Routes of Programs
  get "/functions" => "function#show"
  get "/functions/filter" => "function#filter"
    
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
