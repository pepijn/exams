class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :level, index: true
      t.references :user, index: true

      t.timestamps
    end

    change_table :answers do |t|
      t.references :session
    end
  end
end
