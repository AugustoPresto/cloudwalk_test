class Repository < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :stars, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
