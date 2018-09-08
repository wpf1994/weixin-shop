class CancelOrderDetail < ActiveRecord::Base
  belongs_to :cancel_order, class_name: 'CancelOrder'
  belongs_to :shop_commodity
  belongs_to :commodity

end
