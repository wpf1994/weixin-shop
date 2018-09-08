json.array!(@admin_attachments) do |admin_attachment|
  json.extract! admin_attachment, :id, :name, :avatar, :author_id, :position, :data_type
  json.url admin_attachment_url(admin_attachment, format: :json)
end
