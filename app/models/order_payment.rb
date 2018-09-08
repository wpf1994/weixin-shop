class OrderPayment < ActiveRecord::Base
  belongs_to :order, class_name: 'Order'
  belongs_to :user, class_name: 'User'
end
