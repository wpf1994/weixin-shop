json.array!(@admin_customers) do |admin_customer|
  json.extract! admin_customer, :id, :name, :member_number, :phone, :email, :score, :weixin_id, :lase_shop_id
  json.url admin_customer_url(admin_customer, format: :json)
end
