json.array!(@shipping_search_info) do |shopping|
  json.commodity do
    json.extract! shopping, :id, :name
    json.shop_commodities do
      json.id shopping.sc_id
      json.price shopping.price
    end
    json.class_name shopping.classification.name
    json.num 1
    json.class_id 0
    json.cover shopping.cover.avatar.url if !shopping.cover.blank?
  end
end
