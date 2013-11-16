class LargerOptionsText < ActiveRecord::Migration
  def change
    change_column :options, :text, :text
  end
end
