# == Schema Information
#
# Table name: users
#
#  id                    :integer         not null, primary key
#  email                 :string(255)
#  name                  :string(255)
#  nickname              :text
#  bio                   :text
#  image_url             :text
#  newsletter            :boolean         default(FALSE)
#  project_updates       :boolean         default(FALSE)
#  created_at            :datetime
#  updated_at            :datetime
#  full_name             :text
#  address_street        :text
#  address_number        :text
#  address_complement    :text
#  address_neighbourhood :text
#  address_city          :text
#  address_state         :text
#  address_zip_code      :text
#  phone_number          :text
#  credits               :decimal(, )     default(0.0)
#  locale                :string(255)     default("en"), not null
#  admin                 :boolean         default(FALSE)
#

# coding: utf-8
class User < ActiveRecord::Base
  
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  
  validates_presence_of :provider, :uid, :site
  validates_uniqueness_of :uid, :scope => :provider
  validates_length_of :bio, :maximum => 140
  validates :email, :email => true, :allow_nil => true, :allow_blank => true
  
  has_many :backs, :class_name => "Backer"
  has_many :projects
  has_many :notifications
  has_many :comments
  has_many :secondary_users, :class_name => 'User', :foreign_key => :primary_user_id
  belongs_to :site
  belongs_to :primary, :class_name => 'User', :foreign_key => :primary_user_id
  
  scope :primary, :conditions => ["primary_user_id IS NULL"]
  scope :backers, :conditions => ["id IN (SELECT DISTINCT user_id FROM backers WHERE confirmed)"]
  #before_save :store_primary_user
  
  before_create  :update_newsletter_subscription, :if => Proc.new { |u| u.newsletter_changed? }
  before_update  :update_newsletter_subscription, :if => Proc.new { |u| u.newsletter_changed? }

  def store_primary_user
    return if email.nil? or self.primary_user_id
    primary_user = User.primary.where(:email => email).first
    if primary_user and primary_user.id != self.id
      self.primary_user_id = primary_user.id
    end
  end

  def to_param
    return "#{self.id}" unless self.display_name
    "#{self.id}-#{self.display_name.parameterize}"
  end

  def self.find_with_omni_auth(provider, uid)
    u = User.find_by_provider_and_uid(provider, uid)
    return nil unless u
    u.primary.nil? ? u : u.primary
  end

  def self.create_with_omniauth(site, auth, primary_user_id = nil)
    u = create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
      user.name = auth["user_info"][:name] if user.name.nil?
      user.email = auth["user_info"]["email"]
      user.email = auth["extra"]["user_hash"]["email"] if auth["extra"] and auth["extra"]["user_hash"] and user.email.nil?
      user.nickname = auth["user_info"]["nickname"]
      user.bio = auth["user_info"]["description"][0..139] if auth["user_info"]["description"]
      user.image_url = auth["user_info"]["image"]
      user.site = site
      user.locale = I18n.locale.to_s
    end
    # If we could not associate by email we try to use the parameter
    if u.primary.nil? and primary_user_id
      u.primary = User.find_by_id(primary_user_id)
    end
    u.primary.nil? ? u : u.primary
  end
  
  def display_name
    name || nickname || I18n.t('user.no_name')
  end
  
  def short_name
    truncate display_name, :length => 26
  end
  
  def medium_name
    truncate display_name, :length => 42
  end
  
  def display_image
    gravatar_url || image_url || '/images/user.png'
  end
  
  def backer?
    backs.confirmed.not_anonymous.count > 0
  end
  
  def total_backs
    backs.confirmed.not_anonymous.count
  end
  
  def backs_text
    if total_backs == 2
      I18n.t('user.backs_text.two')
    elsif total_backs > 1
      I18n.t('user.backs_text.many', :total => (total_backs-1))
    else
      I18n.t('user.backs_text.one')
    end
  end
  
  def remember_me_hash
    Digest::MD5.new.update("#{self.provider}###{self.uid}").to_s
  end
  
  def display_credits
    number_to_currency credits, :locale => I18n.locale
  end
  
  def merge_into!(new_user)
    self.primary = new_user
    new_user.credits += self.credits
    self.credits = 0
    self.backs.update_all :user_id => new_user.id
    self.projects.update_all :user_id => new_user.id
    self.comments.update_all :user_id => new_user.id
    self.notifications.update_all :user_id => new_user.id
    self.save
    new_user.save
  end

  def can_edit?( project )
    return true if self.admin?

    current_project = self.projects.find_by_id( project.id )

    unless current_project.nil?
      !current_project.approved?( current_project.site )
    else
      false
    end
  end

  def as_json(options={})
    {
      :id => id,
      :email => email,
      :name => display_name,
      :short_name => short_name,
      :medium_name => medium_name,
      :image => display_image,
      :total_backs => total_backs,
      :backs_text => backs_text,
      :url => user_path(self),
      :admin => admin
    }
  end
  
  def update_newsletter_subscription
    if self.email?
      mimi = MadMimi.new( ENV['MADMIMI_USERNAME'] , ENV['MADMIMI_API_KEY'] )
      self.newsletter? ? mimi.add_to_list( self.email, 'newsletter' ) : mimi.remove_from_list( self.email, 'newsletter' )
    end  
  end

  protected

  # Returns a Gravatar URL associated with the email parameter
  def gravatar_url
    return unless email
    "http://gravatar.com/avatar/#{Digest::MD5.new.update(email)}.jpg?default=#{image_url or "http://catarse.me/images/user.png"}"
  end
  
end
