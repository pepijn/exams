class AddQuestionStackToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :question_stack, array: true, default: []
    end

    change_table :exams do |t|
      t.timestamps
    end
  end
end
