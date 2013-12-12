class OrdersController < ProtectedController
  def new
    @order = current_user.orders.build
  end

  def create
    @order = current_user.orders.build order_params
    @order.save

    payment = Qantani.execute(
      amount: @order.credits == 100 ? 2 : 5,
      bank_id: params[:bank_id],
      description: "tentamens.plict.nl #10#{@order.id}",
      return_url: payment_url
    )

    @order.transaction_id = payment.transaction_id
    @order.transaction_code = payment.transaction_code

    if @order.save
      redirect_to payment.bank_url
    else
      render :new
    end
  end

  private

  def order_params
    params.permit(:credits)
  end
end

