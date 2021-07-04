class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.string :image_id
      t.string :password_digest

      t.timestamps
    end
  end
end
