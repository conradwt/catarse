# == Schema Information
#
# Table name: oauth_providers
#
#  id         :integer(4)      not null, primary key
#  name       :text            default(""), not null
#  key        :text            default(""), not null
#  secret     :text            default(""), not null
#  scope      :text
#  order      :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  strategy   :text
#  path       :text
#

class OauthProvider < ActiveRecord::Base
end
