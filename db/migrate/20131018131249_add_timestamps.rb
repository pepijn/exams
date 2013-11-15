class AddTimestamps < ActiveRecord::Migration
  def change
    change_table :sessions do |t|
      t.timestamps
    end
  end
end
