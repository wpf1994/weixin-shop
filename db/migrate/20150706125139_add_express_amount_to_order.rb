class AddExpressAmountToOrder < ActiveRecord::Migration
  def change
    change_table :orders do |c|
      c.float :express_amount
    end
  end
end
