class OrderDetail < ActiveRecord::Base
  belongs_to :order, class_name: 'Order'
  belongs_to :shop_commodity, class_name: 'ShopCommodity'
  belongs_to :commodity, class_name: 'Commodity'
end
