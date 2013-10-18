class AddSessions < ActiveRecord::Migration
  def change
    Answer.delete_all
    create_table :sessions do |t|
      t.integer :question_stack, array: true, default: []
      t.references :user, null: false
    end

    change_table :users do |t|
      t.remove :question_stack
    end

    change_table :answers do |t|
      t.references :session, null: false
      t.remove :user_id
    end
  end
end
