class AddInputToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :input, :string
  end
end
