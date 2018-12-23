class Notice < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: {minimum: 5}
end
