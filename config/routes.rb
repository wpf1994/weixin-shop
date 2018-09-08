Scaffold::Application.routes.draw do
  namespace :front do
    get 'portal/index'
  end

  devise_for :users, skip: [:registrations], controllers: {sessions: 'common/sessions'}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'portal#index'
  get 'shop' => 'front/homes#home'
  get 'admin' => 'admin/users#index'

  get 'free_express' => 'portal#free_express'
  get 'get_addr/:id' => 'portal#get_addr'
  get 'notice/:id' => 'portal#notice'
  post 'save_addr' => 'portal#save_addr'

  namespace :front do |front|
    namespace :homes do
      get :pay_view
      post :pay_call_back
      get :express
      get :home_index, format: 'json'
      get :get_classification
      get :get_shop
      get :get_region_shop
      get :shipping_address
      get :shipping_address_default
      get :get_order_old
      get :get_order_ing
      get :get_order_detail
      get :get_score_detail
      get :get_person_info
      post :commentary_order
      post :shipping_address_change
      post :shipping_address_new
      post :order_new
      get :cancel_order_customer
      post :express_entrue
      post :pay_online
      post :change_person_info
      post :search_shipping_info
    end
    resources :contacts do
      collection do
        get :upload
        post :upload_file
        get :tree_data, format: 'json'
      end
    end

    get 'users/edit' => 'users#edit'
    patch 'users/update' => 'users#update'
    get 'users/update_password' => 'users#update_password'
    patch 'users/update_password' => 'users#update_password'
    resources :user_bills, only: [:index, :show]
  end

  namespace :admin do |admin|

    get 'roles/tree_data/:type' => 'roles#tree_data'
    post 'roles/destroy_multi' => 'roles#destroy_multi'
    post 'users/destroy_multi' => 'users#destroy_multi'
    post 'permissions/destroy_multi' => 'permissions#destroy_multi'
    post 'organizations/destroy_multi' => 'organizations#destroy_multi'
    post 'code_tables/destroy_multi' => 'code_tables#destroy_multi'
    post 'attachments/destroy_multi' => 'attachments#destroy_multi'
    post 'customers/destroy_multi' => 'customers#destroy_multi'
    post 'classifications/destroy_multi' => 'classifications#destroy_multi'
    post 'commodities/destroy_multi' => 'commodities#destroy_multi'
    post 'communities/destroy_multi' => 'communities#destroy_multi'
    post 'shops/destroy_multi' => 'shops#destroy_multi'
    post 'employees/destroy_multi' => 'employees#destroy_multi'
    post 'orders/destroy_multi' => 'orders#destroy_multi'
    post 'order_infos/destroy_multi' => 'order_infos#destroy_multi'
    post 'manage_orders/destroy_multi' => 'manage_orders#destroy_multi'
    post 'order_comments/destroy_multi' => 'order_comments#destroy_multi'
    post 'shop_commodities/destroy_multi' => 'shop_commodities#destroy_multi'
    post 'shop_manage_users/destroy_multi' => 'shop_manage_users#destroy_multi'
    post 'express_orders/destroy_multi' => 'express_orders#destroy_multi'
    post 'notices/destroy_multi' => 'notices#destroy_multi'
    post 'adverts/destroy_multi' => 'adverts#destroy_multi'

    resources :dummy_shop_orders
    resources :shop_manage_users
    namespace :shop_statistics do
      get :index
      post :shop_total
      post :shop_all_total
      post :get_data
      post :hot_shipping_total
      post :hot_shipping_single
      post :express_num_total
    end
    resources :cancel_orders do |c|
      collection do
        get :index
        get :new
        post :get_shipping
        post :save_info
      end
    end
    resources :manage_orders do |c|
      collection do
        get :read_order_count, format: 'json'
        post :add_express_seller
      end
    end
    resources :order_infos do |c|
      collection do

      end
    end
    resources :roles
    resources :attachments
    resources :code_tables
    resources :organizations
    resources :permissions
    resources :customers
    resources :classifications

    get 'commodities/upload' => 'commodities#upload'
    post 'commodities/upload' => 'commodities#upload'
    resources :commodities
    resources :communities
    resources :shops
    resources :shop_commodities do
      collection do
        get :set_has_long
        get :change_left_count
      end
    end
    resources :order_comments
    resources :employees
    resources :orders
    resources :users do
      collection do
        get 'validate_user'
        get 'update_password'
        patch 'update_password'
      end
    end

    resources :express_orders do
      collection do
        get 'read_express_count'
      end
    end
    resources :adverts
    resources :notices
  end

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
