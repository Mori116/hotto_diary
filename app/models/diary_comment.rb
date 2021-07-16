class DiaryComment < ApplicationRecord
  belongs_to :user
  belongs_to :diary
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true

  def create_notification_comment!(current_user, comment_id, diary_user_id)
    user_id = diary.user_id
    save_notification_comment!(current_user, self.id, user_id)
    # 日記作成者のみに通知する
  end

  def save_notification_comment!(current_user, diary_comment_id, visited_id)
      notification = current_user.active_notifications.new(
      diary_id: self.diary_id,
      diary_comment_id: diary_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    # 自分の投稿に自分がコメントした場合は、通知済みとする
    end
    notification.save
  end

end
