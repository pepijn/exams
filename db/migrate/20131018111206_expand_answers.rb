class ExpandAnswers < ActiveRecord::Migration
  def change
    Answer.delete_all
    change_table :answers do |t|
      t.references :question, null: false
      t.references :user, null: false
      t.change :option_id, :integer, null: true
    end
  end
end

