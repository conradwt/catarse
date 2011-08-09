class CreateProjectsSites < ActiveRecord::Migration

  def self.up

    create_table :projects_sites do |t|
      t.references :project, :null => false
      t.references :site, :null => false
      t.boolean :visible, :null => false, :default => false
      t.boolean :rejected, :null => false, :default => false
      t.boolean :recommended, :null => false, :default => false
      t.boolean :home_page, :null => false, :default => false
      t.integer :order
      t.timestamps
    end

  end

  def self.down
    
    drop_table :projects_sites
    
  end
  
end
