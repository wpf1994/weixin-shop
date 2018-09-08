json.array!(@admin_manage_orders) do |admin_manage_order|
  json.extract! admin_manage_order, :id
  json.url admin_manage_order_url(admin_manage_order, format: :json)
end
