class ExpressOrder < ActiveRecord::Base
  belongs_to :shop
  belongs_to :courier, class_name: 'User', foreign_key: 'courier_id'
end
