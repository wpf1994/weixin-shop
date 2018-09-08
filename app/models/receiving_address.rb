class ReceivingAddress < ActiveRecord::Base
  belongs_to :customer
  belongs_to :community
  belongs_to :shop
end
