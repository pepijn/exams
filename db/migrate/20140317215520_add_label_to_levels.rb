class AddLabelToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :label, :string
  end
end
