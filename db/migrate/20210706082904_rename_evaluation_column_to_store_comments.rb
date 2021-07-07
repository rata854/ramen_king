class RenameEvaluationColumnToStoreComments < ActiveRecord::Migration[5.2]
  def change
    
    rename_column :store_comments, :evaluation, :rate
    
  end
end
