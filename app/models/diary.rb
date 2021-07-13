class Diary < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :notifications, dependent: :destroy
  has_many :diary_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 800 }

  attachment :image

  scope :user_order_desc_per_10, -> page {
    joins(:user).where(users: {is_deleted: false}).order(created_at: :desc).page(page).per(10)
    # 有効ステータスのユーザを取得。作成日を降順で１０レコードずつ表示。
  }

end
