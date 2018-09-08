class CancelOrder < ActiveRecord::Base
  belongs_to :order, class_name: 'Order'
  belongs_to :shop, class_name: 'Shop'
  belongs_to :user, class_name: 'User'
  has_many :cancel_order_details
  has_many :commodities, through: :cancel_order_details
end
