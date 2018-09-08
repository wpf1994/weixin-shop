json.array!(@admin_notices) do |admin_notice|
  json.extract! admin_notice, :id, :title, :content, :author, :public_at
  json.url admin_notice_url(admin_notice, format: :json)
end
