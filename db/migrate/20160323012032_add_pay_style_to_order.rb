class AddPayStyleToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :pay_style, :integer
  end
end
