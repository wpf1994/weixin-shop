class Customer < ActiveRecord::Base
  belongs_to :lase_shop, class_name: 'Shop', foreign_key: 'lase_shop_id'
  has_many :receiving_addresses
  has_many :score_records

end
