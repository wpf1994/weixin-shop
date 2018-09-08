class Shop < ActiveRecord::Base
  has_many :customers
  belongs_to :region, class_name: 'CodeTable'
  belongs_to :parent, class_name: 'Shop'
  has_many :children, -> { order position: :asc }, class_name: 'Shop', foreign_key: 'parent_id'
  has_many :commodities, through: :shop_commodities
  has_many :shop_commodities
  has_many :commodities, through: :shop_commodities
  has_one :user, as: :owner
  has_many :employees

  has_many :managers, class_name: 'User', foreign_key: 'shop_manage_id'
  has_many :express_orders
end
