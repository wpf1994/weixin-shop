json.array!(@admin_express_orders) do |admin_express_order|
  json.extract! admin_express_order, :id, :consignee, :phone, :address, :status, :shop_id, :courier_id, :serial_number, :completed_at
  json.url admin_express_order_url(admin_express_order, format: :json)
end
