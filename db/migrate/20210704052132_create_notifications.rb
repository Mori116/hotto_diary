class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :diary_id
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :diary_comment_id
      t.string :action
      t.boolean :checked, default: false

      t.timestamps
    end
  end
end
