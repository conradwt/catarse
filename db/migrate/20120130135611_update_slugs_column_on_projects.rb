class UpdateSlugsColumnOnProjects < ActiveRecord::Migration
  
  def up
    Project.find_each(&:save)
  end

  def down
    Project.find_each do | project |
      project.name = ''
    end
  end
  
end
