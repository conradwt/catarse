# coding: utf-8
class BackersController < ApplicationController
  
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error
  
  inherit_resources
  
  actions :new, :create
  
  # before_filter :initialize_paypal
  
  # GET /projects/:id/new
  # GET /projects/:id/new.json
  def new
    
    return unless require_login
    
    new! do
      
      # Locate the current project.
      @project = Project.find( params[:project_id] )
       
      unless @project.can_back?(current_site)
        flash[:failure] = t('projects.back.cannot_back')
        return redirect_to :root
      end

      # Instantiate a backer for this project.
      @backer = @project.backers.new( :user => current_user, :site => current_site )
      
      @title = t('projects.back.title', :name => @project.name)
     
      empty_reward = Reward.new(:id => 0, :minimum_value => 0, :description => t('projects.back.no_reward'))
     
      @rewards = [empty_reward] + @project.rewards.order(:minimum_value)
      @reward = @project.rewards.find params[:reward_id] if params[:reward_id]
      @reward = nil if @reward and @reward.sold_out?
      
      if @reward
        @backer.reward = @reward
        @backer.value = "%0.0f" % @reward.minimum_value
      end
      
    end
        
  end

  def create
    
    # Locate the current project.
    project = Project.find( params[:project_id] )
    
    # Instantiate a backer for this project.
    backer = project.backers.build( params[:backer] )
    backer.user = current_user
    backer.site = current_site
    backer.save!

    begin
      paypal_response = @paypal.setup(
        paypal_payment( backer ),
        success_project_backers_url( backer ),
        cancel_project_backers_url( backer ),
        :no_shipping => true
      )
      redirect_to paypal_response.redirect_uri
    #rescue Paypal::Exception::APIError => e
    #  raise "Message: #{e.message}<br/>Response: #{e.response.inspect}<br/>Details: #{e.response.details.inspect}"
    rescue
      flash[:failure] = t('projects.pay.paypal_error')
      return redirect_to new_project_backer_path( project )
    end
  end

  def success
    backer = Backer.find params[:id]
    begin
      details = @paypal.details(params[:token])
      checkout = @paypal.checkout!(
        params[:token],
        details.payer.identifier,
        paypal_payment(backer)
      )
      if checkout.payment_info.first.payment_status == "Completed"
        backer.update_attribute :key, checkout.payment_info.first.transaction_id
        backer.confirm!
        flash[:success] = t('projects.pay.success')
        redirect_to thank_you_path
      else
        flash[:failure] = t('projects.pay.paypal_error')
        return redirect_to new_project_backer_path( project )
      end
    rescue
      flash[:failure] = t('projects.pay.paypal_error')
      return redirect_to new_project_backer_path( project )
    end
  end
  
  def cancel
    backer = Backer.find params[:id]
    flash[:failure] = t('projects.pay.paypal_cancel')
    redirect_to new_project_backer_path( project )
  end

  protected
  
  # def initialize_paypal
  #   # TODO remove the sandbox! when ready
  #   Paypal.sandbox!
  #   # TODO remove the sandbox! when ready
  #   
  #   @paypal = Paypal::Express::Request.new(
  #     :username   => 'seller_1316500625_biz_api1.yahoo.com', # Configuration.find_by_name('paypal_username').value,
  #     :password   => '1316500662', #Configuration.find_by_name('paypal_password').value,
  #     :signature  => 'Ay0WGeDNE3scjpjgVSFjMHA6ARRFACyjEgEFZfKzqqRzGIEnfyLN0RDx' # Configuration.find_by_name('paypal_signature').value
  #   )
  # end
  
  def paypal_payment( backer )
    Paypal::Payment::Request.new(
      :currency_code => :USD,
      :amount => backer.value,
      :description => t('projects.pay.paypal_description'),
      :items => [{
          :name => backer.project.name,
          :description => t('projects.pay.paypal_description'),
          :amount => backer.value#,
          #:category => :Digital
        }]
    )
  end
  
  private

  # def handle_callback
  #   backer = Backer.find_by_token! params[:token]
  #   @redirect_uri = yield backer
  #   if backer.popup?
  #     render :close_flow, layout: false
  #   else
  #     redirect_to @redirect_uri
  #   end
  # end

  def paypal_api_error(e)
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end
  
end