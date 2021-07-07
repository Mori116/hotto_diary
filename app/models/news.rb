class News < ApplicationRecord
  validates :body, presence: true
end
