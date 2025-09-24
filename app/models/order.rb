class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart, optional: true
  has_many :order_items, dependent: :destroy

  validates :status, presence: true
  before_validation :set_default_status, on: :create

  def calculate_total!
    update!(total_cents: order_items.sum("quantity * price_cents"))
  end

  private

  def set_default_status
    self.status ||= "pending"
  end
end
