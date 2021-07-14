class RenameStoreIntroductionColumnToStores < ActiveRecord::Migration[5.2]
  def change
    rename_column :stores, :store_introduction, :menu
  end
end
