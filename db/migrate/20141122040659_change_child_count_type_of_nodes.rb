class ChangeChildCountTypeOfNodes < ActiveRecord::Migration
  def change
    change_column :nodes, :child_count, :integer, default: 0
  end
end
