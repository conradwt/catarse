class CreateRewards < ActiveRecord::Migration

  def self.up

    create_table :rewards do |t|
      t.references :project, :null => false
      t.decimal :minimum_value, :null => false
      t.integer :maximum_backers, :null => true
      t.text :description, :null => false
      t.timestamps
    end
    
    add_index :rewards, :project_id
    
  end
  
  def self.down
    
    drop_table :rewards
    
  end
  
end
