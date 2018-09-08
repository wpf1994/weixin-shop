json.array!(@admin_orders) do |admin_order|
  json.extract! admin_order, :id, :custom, :shop, :payed_at, :total_amount, :commodity_amount, :express_amount, :consume_score, :consume_amount, :actual_amount, :actual_reason, :status, :set_out_at
  json.url admin_order_url(admin_order, format: :json)
end
