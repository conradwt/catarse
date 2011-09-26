# coding: utf-8
class BackerssController < ApplicationController
  
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

  # POST /projects/:id/backers
  # POST /projects/:id/backers.json
  def create
    
    @project = Project.find( params[:project_id] )
    
    respond_to do |format|
      
      if @project
        
        # TODO:  Do payment.

        @backer = @project.backers.build( params[:backer] )
      
        if @backer.save
          format.html { redirect_to @project, notice: 'Backer was successfully created.' }
          format.json { render json: @project, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
        
      else
        
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
        
      end
      
    end
      
  end
  
end