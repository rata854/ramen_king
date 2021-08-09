class AddBusinessStatusToStores < ActiveRecord::Migration[5.2]
  def change
    add_column :stores, :business_status, :integer, default: 0
  end
end
