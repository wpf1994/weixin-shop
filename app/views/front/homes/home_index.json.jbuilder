json.array!(@shopping) do |shopping|
  json.commodity do
    json.extract! shopping, :id, :name, :is_fictitious, :show_content
    json.shop_commodities do
      json.id shopping.sc_id
      json.price shopping.price
    end
    json.class_name shopping.classification.name
    json.class_id shopping.classification.id
    json.num 1
    json.cover shopping.cover.avatar.url(:thumb) if !shopping.cover.blank?
  end
end
