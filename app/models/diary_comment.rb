class DiaryComment < ApplicationRecord
  belongs_to :user
  belongs_to :diary
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true
end
