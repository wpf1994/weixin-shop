json.array!(@admin_communities) do |admin_community|
  json.extract! admin_community, :id, :name, :kind, :region_id
  json.url admin_community_url(admin_community, format: :json)
end
