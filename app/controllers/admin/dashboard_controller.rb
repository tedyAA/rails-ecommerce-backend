class Admin::DashboardController < AdminController
  def index
    @total_orders = Order.count
    @total_items_ordered = OrderItem.sum(:quantity)
    @total_users = User.count
    @users_this_week = User.where("created_at >= ?", 1.week.ago).count
    @total_revenue = Order.sum(:total_cents)

  end

  def show
  end
end
