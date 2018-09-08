json.array!(@admin_permissions) do |admin_permission|
  json.extract! admin_permission, :id, :action, :subject, :description, :code, :group_id, :fetching
  json.url admin_permission_url(admin_permission, format: :json)
end
