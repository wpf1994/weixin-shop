json.array!(@admin_order_infos) do |admin_order_info|
  json.extract! admin_order_info, :id
  json.url admin_order_info_url(admin_order_info, format: :json)
end
