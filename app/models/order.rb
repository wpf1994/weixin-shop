class Order < ActiveRecord::Base
  has_many :score_records
  belongs_to :customer, class_name: 'Customer'
  belongs_to :shop, class_name: 'Shop'
  has_many :order_details
  has_one :order_express
  has_many :order_logs
  has_many :order_details
  has_many :dummy_shop_orders
end
