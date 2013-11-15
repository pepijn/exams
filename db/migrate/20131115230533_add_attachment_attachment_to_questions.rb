class AddAttachmentAttachmentToQuestions < ActiveRecord::Migration
  def self.up
    change_table :questions do |t|
      t.attachment :attachment
    end
  end

  def self.down
    drop_attached_file :questions, :attachment
  end
end
