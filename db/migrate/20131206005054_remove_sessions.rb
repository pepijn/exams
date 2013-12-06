class RemoveSessions < ActiveRecord::Migration
  def change
    drop_table :sessions
    remove_column :answers, :session_id

    change_table :answers do |t|
      t.references :user
    end
  end
end

