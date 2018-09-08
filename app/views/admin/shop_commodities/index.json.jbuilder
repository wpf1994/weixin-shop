json.array!(@admin_shop_commodities) do |admin_shop_commodity|
  json.extract! admin_shop_commodity, :id, :shop_id, :commodity_id, :price, :position, :enable, :sales_volume
  json.url admin_shop_commodity_url(admin_shop_commodity, format: :json)
end
