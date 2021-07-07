class Group < ApplicationRecord
  has_secure_password
  # 暗号化パスワード

  has_many :group_users
  has_many :users, through: :group_users
  has_many :diaries

  validates :name, presence: true

  attachment :image

  def owner
    User.find(self.owner_id)
  end

end
