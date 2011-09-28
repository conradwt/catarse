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
    backer.digital = true
    backer.save!
    
    backer.setup!( success_project_backers_url, cancel_project_backers_url )
    
    if backer.popup?
      redirect_to backer.popup_uri
    else
      redirect_to backer.redirect_uri
    end

  end

  def success
    
    # Locate the current project.
    project = Project.find( params[:project_id] )
    
    handle_callback do | backer |
      backer.complete!( params[:PayerID] )
      flash[:notice] = t('projects.pay.success')
      new_project_backer_path( project )
    end

  end
  
  def cancel
    
    # Locate the current project.
    project = Project.find( params[:project_id] )
  
    handle_callback do | backer |
      backer.cancel!
      flash[:warn] = t('projects.pay.paypal_cancel')
      new_project_backer_path( project )
    end

  end

  protected
  
  # def initialize_paypal
  #   @paypal = Paypal::Express::Request.new( PAYPAL_CONFIG )
  # end
  # 
  # def paypal_payment( backer )
  #   Paypal::Payment::Request.new(
  #     :currency_code => :USD,
  #     :amount => backer.value,
  #     :description => t('projects.pay.paypal_description'),
  #     :items => [{
  #         :name => backer.project.name,
  #         :description => t('projects.pay.paypal_description'),
  #         :amount => backer.value#,
  #         #:category => :Digital
  #       }]
  #   )
  # end
  
  private

  def handle_callback
    
    # Locate the current project.
    project = Project.find( params[:project_id] )
    
    # Find the backer by toeken.
    backer = project.backers.find_by_token! params[:token]
    
    @redirect_uri = yield backer
    if backer.popup?
      render :close_flow, layout: false
    else
      redirect_to @redirect_uri
    end
  end

  def paypal_api_error(e)
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end
  
end