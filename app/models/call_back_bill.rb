class CallBackBill < ActiveRecord::Base
  belongs_to :order
  belongs_to :order_place_in
end
