class AddFieldsToBackers < ActiveRecord::Migration
  def change
    add_column :backers, :token, :string
    add_column :backers, :identifier, :string
    add_column :backers, :payer_id, :string
    add_column :backers, :recurring, :boolean, :default => false
    add_column :backers, :digital, :boolean  , :default => false
    add_column :backers, :popup, :boolean    , :default => false
    add_column :backers, :completed, :boolean, :default => false
    add_column :backers, :canceled, :boolean , :default => false
  end
end
