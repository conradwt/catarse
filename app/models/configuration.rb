# == Schema Information
#
# Table name: configurations
#
#  id         :integer(4)      not null, primary key
#  name       :text            default(""), not null
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#

class Configuration < ActiveRecord::Base
  
  validates_presence_of :name
  
end
