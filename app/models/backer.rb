# == Schema Information
#
# Table name: backers
#
#  id               :integer         not null, primary key
#  project_id       :integer         not null
#  user_id          :integer         not null
#  reward_id        :integer
#  value            :decimal(, )     not null
#  confirmed        :boolean         default(FALSE), not null
#  confirmed_at     :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  display_notice   :boolean         default(FALSE)
#  anonymous        :boolean         default(FALSE)
#  key              :integer
#  can_refund       :boolean         default(FALSE)
#  requested_refund :boolean         default(FALSE)
#  refunded         :boolean         default(FALSE)
#  credits          :boolean         default(FALSE)
#  notified_finish  :boolean         default(FALSE)
#  site_id          :integer         default(1), not null
#  token            :string(255)
#  identifier       :string(255)
#  payer_id         :string(255)
#  recurring        :boolean         default(FALSE)
#  digital          :boolean         default(FALSE)
#  popup            :boolean         default(FALSE)
#  completed        :boolean         default(FALSE)
#  canceled         :boolean         default(FALSE)
#

# coding: utf-8
class Backer < ActiveRecord::Base
  
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::DateHelper
  
  belongs_to :project
  belongs_to :user
  belongs_to :reward
  belongs_to :site
  
  validates_presence_of :project, :user, :value, :site
  validates_numericality_of :value, :greater_than_or_equal_to => 10.00
  validate :reward_must_be_from_project
  validates :token, uniqueness: true
  validates :identifier, uniqueness: true
  
  scope :anonymous, where( :anonymous => true )
  scope :not_anonymous, where( :anonymous => false )
  scope :confirmed, where( :completed => true )
  scope :pending, where( :completed => false )
  scope :display_notice,  where( :display_notice => true )
  scope :can_refund,  where( :can_refund => true )
  scope :within_refund_deadline, where( "current_timestamp < (created_at + interval '180 days')" )
  scope :recurring, where( recurring: true )
  scope :digital, where( digital: true )
  scope :popup, where( popup: true )
  
  def self.project_visible(site)
    joins(:project).joins("INNER JOIN projects_sites ON projects_sites.project_id = projects.id").where("projects_sites.site_id = #{site.id} AND projects_sites.visible = true")
  end
  
  after_create :define_key
  
  def define_key
    self.update_attribute :key, Digest::MD5.new.update("#{self.id}###{self.created_at}###{Kernel.rand}").to_s
  end
  
  before_save :confirm?
  
  def confirm?
    if confirmed and confirmed_at.nil?
      self.confirmed_at = Time.now
      self.display_notice = true
    end
  end
  
  def confirm!
    update_attribute :confirmed, true
  end
  
  def reward_must_be_from_project
    return unless reward
    errors.add(:reward, I18n.t('backer.reward_must_be_from_project')) unless reward.project == project
  end
  
  validate :value_must_be_at_least_rewards_value
  
  def value_must_be_at_least_rewards_value
    return unless reward
    errors.add(:value, I18n.t('backer.value_must_be_at_least_rewards_value', :minimum_value => reward.display_minimum)) unless value >= reward.minimum_value
  end
  
  validate :should_not_back_if_maximum_backers_been_reached, :on => :create
  
  def should_not_back_if_maximum_backers_been_reached
    return unless reward and reward.maximum_backers and reward.maximum_backers > 0
    errors.add(:reward, I18n.t('backer.should_not_back_if_maximum_backers_been_reached')) unless reward.backers.confirmed.count < reward.maximum_backers
  end
  
  def display_value
    number_to_currency value, :local => I18n.locale
  end
  
  def display_confirmed_at
    I18n.l(confirmed_at.to_date) if confirmed_at
  end
  
  def moip_value
    "%0.0f" % (value * 100)
  end
  
  def generate_credits!
    return if self.can_refund
    self.user.update_attribute :credits, self.user.credits + self.value
    self.update_attribute :can_refund, true
  end
  
  def refund_deadline
    created_at + 180.days
  end
  
  def as_json(options={})
    {
      :id => id,
      :anonymous => anonymous,
      :confirmed => confirmed,
      :confirmed_at => display_confirmed_at,
      :display_value => display_value,
      :user => user,
      :reward => reward
    }
  end
  
  def goods_type
     digital? ? :digital : :real
   end

   def payment_type
     recurring? ? :recurring : :instant
   end

   def ux_type
     popup? ? :popup : :redirect
   end

   def details
     if recurring?
       client.subscription(self.identifier)
     else
       client.details(self.token)
     end
   end
  
  attr_reader :redirect_uri, :popup_uri
  
  def setup!(return_url, cancel_url)
    response = client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true,
      no_shipping: self.digital?
    )
    self.token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def complete!(payer_id = nil)
    if self.recurring?
      response = client.subscribe!(self.token, recurring_request)
      self.identifier = response.recurring.identifier
    else
      response = client.checkout!(self.token, payer_id, payment_request)
      self.payer_id = payer_id
      self.identifier = response.payment_info.first.transaction_id
    end
    self.completed = true
    self.save!
    self
  end
  
  def unsubscribe!
    client.renew!(self.identifier, :Cancel)
    self.cancel!
  end

  private

  def client
    Paypal::Express::Request.new PAYPAL_CONFIG
  end

  DESCRIPTION = {
    item: 'PayPal Express Sample Item',
    instant: 'PayPal Express Sample Instant Payment',
    recurring: 'PayPal Express Sample Recurring Payment'
  }

  def payment_request
    request_attributes = if self.recurring?
      {
        billing_type: :RecurringPayments,
        billing_agreement_description: DESCRIPTION[:recurring]
      }
    else
      item = {
        :currency_code  => :USD,
        :name           => self.project.name,
        :description    => t('projects.pay.paypal_description')
        :amount         => self.value
      }
      item[:category] = :Digital if self.digital?
      {
        :amount       => self.value,
        :description  => t('projects.pay.paypal_description'),
        items: [item]
      }
    end
    Paypal::Payment::Request.new request_attributes
  end

  def recurring_request
    Paypal::Payment::Recurring.new(
      start_date: Time.now,
      description: DESCRIPTION[:recurring],
      billing: {
        period: :Month,
        frequency: 1,
        amount: self.amount
      }
    )
  end
  
end
