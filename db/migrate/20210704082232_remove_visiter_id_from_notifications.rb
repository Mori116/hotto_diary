class RemoveVisiterIdFromNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :visiter_id, :integer
  end
end
