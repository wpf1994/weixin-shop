json.array!(@admin_commodities) do |admin_commodity|
  json.extract! admin_commodity, :id, :name, :summary, :content, :identifier, :reference_price, :cover_id
  json.url admin_commodity_url(admin_commodity, format: :json)
end
