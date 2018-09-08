json.array!(@admin_order_comments) do |admin_order_comment|
  json.extract! admin_order_comment, :id, :order_id, :shop_id, :total_star, :speed_star, :serve_start, :content
  json.url admin_order_comment_url(admin_order_comment, format: :json)
end
