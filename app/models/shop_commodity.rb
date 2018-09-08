class ShopCommodity < ActiveRecord::Base
  belongs_to :commodity, class_name: 'Commodity'
  belongs_to :shop
end
