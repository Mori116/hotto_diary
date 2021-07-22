class Group < ApplicationRecord
  has_secure_password
  # 暗号化パスワード

  has_many :group_users
  has_many :users, through: :group_users
  has_many :diaries

  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # allow_nil: trueによって、新規作成時は6文字以上のバリデーションが掛かるが、編集時はバリデーションが掛からなくなる

  attachment :image

  def owner
    User.find(self.owner_id)
  end

  scope :order_desc_per_10, -> page {
    order(created_at: :desc).page(page).per(10)
    # 作成日を降順で１０レコードずつ表示。
  }

end
