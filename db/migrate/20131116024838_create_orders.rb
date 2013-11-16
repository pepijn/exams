class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.string :transaction_id
      t.string :transaction_code
      t.text :payment
      t.boolean :paid
      t.integer :credits
      t.string :coupon

      t.timestamps
    end
  end
end
