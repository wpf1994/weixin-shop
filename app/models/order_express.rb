class OrderExpress < ActiveRecord::Base
  belongs_to :order, class_name: 'Order'
  belongs_to :user, class_name: 'User'
  has_many :order_details, through: :order
  has_many :commodities, through: :order_details
end
