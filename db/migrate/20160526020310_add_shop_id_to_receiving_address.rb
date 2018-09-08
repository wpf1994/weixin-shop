class AddShopIdToReceivingAddress < ActiveRecord::Migration
  def change
    add_reference :receiving_addresses, :shop, index: true
  end
end
