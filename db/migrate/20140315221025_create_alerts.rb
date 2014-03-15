class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.references :question, index: true
      t.references :user, index: true
      t.text :message

      t.timestamps
    end
  end
end
