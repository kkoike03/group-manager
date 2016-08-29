Rails.application.routes.draw do
  resources :assign_rental_items do
    # 標準の7つ以外を追加する
    collection do
      get 'item_list'
    end
  end

  get 'health_check_pages/cooking'
  get 'health_check_pages/no_cooking'

  get 'stool_test_pages/check_sheet'
  get 'stool_test_pages/for_examiner_sheet'
  get 'stool_test_pages/for_health_center_sheet'
  get 'rental_item_pages/for_pasting_room_sheet'

  get 'group_information_pages/group_information_sheet'

  resources :group_project_names
  resources :stage_common_options
  resources :rentable_items
  resources :stocker_items
  resources :sub_reps
  resources :purchase_lists do
    # 標準の7つ以外を追加する
    collection do
      get 'index_cooking'
      get 'new_cooking'
      get 'index_noncooking'
      get 'new_noncooking'
    end
  end
  resources :shops
  resources :food_products
  resources :employees
  resources :place_orders
  resources :stage_orders
  resources :power_orders
  resources :rental_orders
  resources :groups
  resources :user_details
  get 'welcome/index'
  get 'welcome/regist_user_detail'

  # deviseのコントローラーをoverrideしたい.
  # ActiveAdmin::Devise.configを上書きする
  config = ActiveAdmin::Devise.config
  config[:controllers][:registrations] = 'registrations'
  devise_for :users, config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
