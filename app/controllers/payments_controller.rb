class PaymentsController < ProtectedController
  def show
    return redirect_to root_url unless params[:id] || params[:checksum]

    @order = Order.find_by_transaction_id params[:id]

    # Save payment information
    @order.payment = Qantani.check(
      transaction_id: @order.transaction_id,
      transaction_code: @order.transaction_code
    )
    @order.save

    # Create tickets if paid
    @order.paid ||= @order.payment.paid?
    @order.save

    if @order.paid?
      redirect_to root_url, notice: "Dankjewel, de bestelling is succesvol! Er zijn #{@order.credits} credits bijgeschreven."
    else
      redirect_to new_order_path, alert: "De bestelling is niet afgerond, probeer het opnieuw"
    end
  end
end


