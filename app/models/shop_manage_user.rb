class ShopManageUser < ActiveRecord::Base
  has_one :user, as: :owner
end
