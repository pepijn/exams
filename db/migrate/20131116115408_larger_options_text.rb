class LargerOptionsText < ActiveRecord::Migration
  def change
    change_column :options, :text, :text
    change_column :answers, :input, :text
  end
end

