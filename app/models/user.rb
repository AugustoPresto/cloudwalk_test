class User < ApplicationRecord
  has_many :repositories

  validates :username, presence: true, uniqueness: true, length: { minimum: 1, maximum: 39 },
                       format: { with: /\A[-a-zA-Z0-9][a-zA-Z0-9_-]*\z/,
                                 message: 'can only contain letters, numbers and dashes' }
end
