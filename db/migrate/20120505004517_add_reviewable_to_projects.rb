class AddReviewableToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :reviewable, :boolean, default: false
  end
end
