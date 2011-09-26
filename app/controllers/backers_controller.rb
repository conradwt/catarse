# coding: utf-8
class BackerssController < ApplicationController
  
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error
  
  # before_filter :initialize_paypal
  
  # GET /projects/:id/new
  # GET /projects/:id/new.json
  def new
    
    @project = Project.find( params[:project_id] )

    @backer = @project.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
    
  end

  def create
    
    project = Project.find( params[:project_id] )
    backer = project.backers.create!( params[:backer] )

    begin
      paypal_response = @paypal.setup(
        paypal_payment( backer ),
        success_project_backers( backer ),
        cancel_project_backers( backer ),
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