class AddStudentNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :student_number, :string
  end
end
