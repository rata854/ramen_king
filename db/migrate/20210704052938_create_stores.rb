class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.integer :user_id
      t.string :store_name
      t.string :store_introduction
      t.string :postal_code
      t.string :address
      t.string :transportation
      t.string :business_day
      t.string :holiday

      t.timestamps
    end
  end
end
