class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.references :author, index: true
      t.integer :position, default: 100
      t.integer :data_type, default: 0

      t.timestamps
    end
    add_attachment :attachments, :avatar
  end
end
