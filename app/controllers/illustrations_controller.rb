class IllustrationsController < ApplicationController
  # GET /illustrations
  # GET /illustrations.json
  def index
    @illustrations = Illustration.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @illustrations }
    end
  end

  # GET /illustrations/1
  # GET /illustrations/1.json
  def show
    @illustration = Illustration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @illustration }
    end
  end

  # GET /illustrations/new
  # GET /illustrations/new.json
  def new
    @illustration = Illustration.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @illustration }
    end
  end

  # GET /illustrations/1/edit
  def edit
    @illustration = Illustration.find(params[:id])
  end

  # POST /illustrations
  # POST /illustrations.json
  def create
    @illustration = Illustration.new(params[:illustration])

    respond_to do |format|
      if @illustration.save
        format.html { redirect_to @illustration, :notice => 'Illustration was successfully created.' }
        format.json { render :json => { :normal_url => @illustration.attachment.url(:normal) }.merge(@illustration.attributes), :status => :created, :location => @illustration }
      else
        format.html { render :action => "new" }
        format.json { render :json => @illustration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /illustrations/1
  # PUT /illustrations/1.json
  def update
    @illustration = Illustration.find(params[:id])

    respond_to do |format|
      if @illustration.update_attributes(params[:illustration])
        format.html { redirect_to @illustration, :notice => 'Illustration was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @illustration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /illustrations/1
  # DELETE /illustrations/1.json
  def destroy
    @illustration = Illustration.find(params[:id])
    @illustration.destroy

    respond_to do |format|
      format.html { redirect_to illustrations_url }
      format.json { head :ok }
    end
  end
end
