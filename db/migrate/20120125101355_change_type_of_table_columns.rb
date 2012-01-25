class ChangeTypeOfTableColumns < ActiveRecord::Migration
  
  def up
    change_column :projects,  :goal,          :integer
    change_column :rewards,   :minimum_value, :integer
  end

  def down
    change_column :projects,  :goal,          :decimal
    change_column :rewards,   :minimum_value, :decimal
  end
  
end
