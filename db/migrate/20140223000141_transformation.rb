class Transformation < ActiveRecord::Migration
  def change
    drop_table :options

    Answer.delete_all
    Question.delete_all
    Exam.delete_all
    Course.delete_all

    Course.create name: "3.3 Psychiatrie"

    change_table :exams do |t|
      t.attachment :source
    end

    create_table :levels do |t|
      t.references :course

      t.timestamps
    end

    change_table :questions do |t|
      t.references :level
      t.text :answer, default: ''
    end

    change_table :answers do |t|
      t.remove :option_id
      t.boolean :correct
    end
  end
end
