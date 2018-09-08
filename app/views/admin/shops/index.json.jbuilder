json.array!(@admin_shops) do |admin_shop|
  json.extract! admin_shop, :id, :name, :address, :phone, :map_location, :region_id, :parent_id, :can_express, :express_amount, :can_express_start_date, :can_express_end_date
  json.url admin_shop_url(admin_shop, format: :json)
end
