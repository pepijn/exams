class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name

      t.timestamps
    end

    change_table :exams do |t|
      t.references :course
    end

    change_table :sessions do |t|
      t.references :course
    end

    bew = Course.create name: "Blok 3.1: Aandoeningen aan het bewegingsapparaat"
    neu = Course.create name: "Blok 3.2: Ziekten van het zenuwstelsel"

    Exam.where(id: [1..4]).each do |e|
      e.update_column :course_id, bew.id
    end

    Exam.where(id: [5..7]).each do |e|
      e.update_column :course_id, neu.id
    end

    Session.all.each do |s|
      s.update_column :course_id, s.created_at > '2013-11-1' ? 2 : 1
    end
  end
end
