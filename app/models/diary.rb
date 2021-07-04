class Diary < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :notifications, dependent: :destroy
  has_many :diary_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 800 }

  attachment :image
end
