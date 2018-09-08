json.array!(@admin_shop_manage_users) do |admin_shop_manage_user|
  json.extract! admin_shop_manage_user, :id, :name, :phone
  json.url admin_shop_manage_user_url(admin_shop_manage_user, format: :json)
end
