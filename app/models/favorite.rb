class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :portfolio
  validates :user_id, presence: true
  validates :portfolio_id, presence: true
end
