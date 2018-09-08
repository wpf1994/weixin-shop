json.array!(@admin_classifications) do |admin_classification|
  json.extract! admin_classification, :id, :name, :parent_id, :position,:single_statistics
  json.url admin_classification_url(admin_classification, format: :json)
end
