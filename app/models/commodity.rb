class Commodity < ActiveRecord::Base
  belongs_to :cover, class_name: 'Attachment', foreign_key: 'cover_id'
  has_many :shop_commodities
  has_many :shops, through: :shop_commodities
  has_many :order_details
  belongs_to :classification

  accepts_nested_attributes_for :cover, allow_destroy: true

  after_create :create_shop_commodities

  private
  def create_shop_commodities
    #创建一个商品就要创建商品和商店的配置
    shops = Shop.select(:id).all
    shop_commodities = []
    shops.each do |shop|
      shop_commodities << {shop_id: shop.id, commodity_id: self.id, price: self.reference_price, }
    end
    ShopCommodity.create(shop_commodities) if shop_commodities.length > 0
  end
end
