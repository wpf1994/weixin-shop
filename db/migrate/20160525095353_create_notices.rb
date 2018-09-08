class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title
      t.text :content
      t.string :author
      t.datetime :public_at

      t.timestamps
    end
  end
end
