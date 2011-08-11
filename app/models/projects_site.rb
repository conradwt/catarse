# == Schema Information
#
# Table name: projects_sites
#
#  id          :integer(4)      not null, primary key
#  project_id  :integer(4)      not null
#  site_id     :integer(4)      not null
#  visible     :boolean(1)      default(FALSE), not null
#  rejected    :boolean(1)      default(FALSE), not null
#  recommended :boolean(1)      default(FALSE), not null
#  home_page   :boolean(1)      default(FALSE), not null
#  order       :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class ProjectsSite < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :site
  
  validates_presence_of :project, :site
  
end
