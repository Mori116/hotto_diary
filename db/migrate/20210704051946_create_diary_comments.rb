class CreateDiaryComments < ActiveRecord::Migration[5.2]
  def change
    create_table :diary_comments do |t|
      t.text :comment
      t.integer :user_id
      t.integer :diary_id

      t.timestamps
    end
  end
end
