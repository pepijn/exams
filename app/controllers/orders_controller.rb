class OrdersController < ProtectedController
  def new
    @order = current_user.orders.build

  end
end

