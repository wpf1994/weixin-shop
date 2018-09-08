json.array!(@admin_organizations) do |admin_organization|
  json.extract! admin_organization, :id, :name, :parent_id, :position, :remark
  json.url admin_organization_url(admin_organization, format: :json)
end
