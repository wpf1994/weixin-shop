class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.string :name
      t.string :title
      t.string :link
      t.attachment :cover

      t.timestamps
    end
  end
end
