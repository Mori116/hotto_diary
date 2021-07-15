class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :diaries, dependent: :destroy

  has_many :diary_comments, dependent: :destroy
  # コメント機能

  has_many :group_users
  has_many :groups, through: :group_users
  # グループ機能

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 自分からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  # 相手からの通知

  scope :not_deleted, -> { where(is_deleted: false) }

  validates :last_name, :first_name, :nickname, presence: true
  validates :last_name_kana, :first_name_kana, presence: true, format: { with: /\p{katakana}/ }

  def active_for_authentication?
    super && (self.is_deleted == false)
  end
  # deviseのactive_for_authentication?を上書き
  # userのis_deletedがfalseならtrueを返す

  def inactive_message
    "退会済みのアカウントです。"
  end
  # deviseのinactive_messageを上書き

  def full_name
    self.last_name + self.first_name
  end

  def check_notifications
    passive_notifications.unchecked.each do |notification|
      notification.update(checked: true)
    end
  end


end
