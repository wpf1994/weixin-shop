class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :action #操作
      t.string :subject #对象
      t.string :description
      t.string :code #执行代码
      t.references :group, index: true
      t.string :fetching  #

      t.timestamps
    end
  end
end
