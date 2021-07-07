class RemoveTitleFromNews < ActiveRecord::Migration[5.2]
  def change
    remove_column :news, :title, :string
  end
end
