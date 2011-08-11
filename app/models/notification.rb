# == Schema Information
#
# Table name: notifications
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)      not null
#  project_id    :integer(4)
#  text          :text            default(""), not null
#  twitter_text  :text
#  facebook_text :text
#  email_subject :text
#  email_text    :text
#  dismissed     :boolean(1)      default(FALSE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  site_id       :integer(4)      default(1), not null
#

class Notification < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :project
  belongs_to :site
  
  validates_presence_of :user, :text, :site
  
  scope :not_dismissed, where(:dismissed => false)
  
  after_create :send_email
  
  def send_email
    return unless self.email_subject and self.email_text and self.user.email
    UsersMailer.notification_email(self).deliver
  rescue
  end
  
end
