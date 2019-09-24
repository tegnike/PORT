class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :portfolio
  validates :user_id, presence: true
  validates :portfolio_id, presence: true

  def self.ranking
    self.group(:portfolio_id).order(Arel.sql("count(portfolio_id) desc")).limit(10).pluck(:portfolio_id)
  end
end
