json.array!(@shop_area) do |shop_info|
  json.shop_area do
    json.extract! shop_info, :id, :name
    json.shops do
      json.array!(shop_info.shops) do |shop|
        json.id shop.id
        json.name shop.name
      end
    end
  end
end
