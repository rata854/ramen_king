class CreateStoreComments < ActiveRecord::Migration[5.2]
  def change
    create_table :store_comments do |t|
      t.integer :user_id
      t.integer :store_id
      t.string :title
      t.text :introduction
      t.string :product_image_id
      t.float :evaluation
      t.integer :genre, null: false, default: 0

      t.timestamps
    end
  end
end
