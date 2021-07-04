class AddVisitorIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :visitor_id, :integer
  end
end
