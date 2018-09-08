class OrderComment < ActiveRecord::Base
  belongs_to :order, class_name: 'Order'
  belongs_to :shop, class_name: 'Shop'
end