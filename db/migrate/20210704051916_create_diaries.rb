class CreateDiaries < ActiveRecord::Migration[5.2]
  def change
    create_table :diaries do |t|
      t.string :title
      t.text :body
      t.string :image_id
      t.boolean :status, default: false
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
