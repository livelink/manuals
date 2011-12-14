class ChaptersController < ApplicationController
  # GET /manual/:manual_id/chapters
  # GET /chapters.json
  def index
	@manual = Manual.find(params[:manual_id])
    @chapters = @manual.chapters.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render :json => @chapters }
    end
  end

  def preview
  end

  # GET /chapters/1
  # GET /chapters/1.json
  def show
	@manual = Manual.find(params[:manual_id])
    @chapter = @manual.chapters.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render :json => @chapter }
    end
  end

  # GET /chapters/new
  # GET /chapters/new.json
  def new
	@manual = Manual.find(params[:manual_id])
    @chapter = @manual.chapters.new
	@chapter.chapter_no = @manual.chapters.count + 1

    respond_to do |format|
      format.html # new.html.haml
      format.json { render :json => @chapter }
    end
  end

  # GET /chapters/1/edit
  def edit
	@manual = Manual.find(params[:manual_id])
    @chapter = @manual.chapters.find(params[:id])
  end

  # POST /chapters
  # POST /chapters.json
  def create
	@manual = Manual.find(params[:manual_id])
    @chapter = @manual.chapters.new(params[:chapter])

    respond_to do |format|
      if @chapter.save
        format.html { redirect_to @manual, :notice => 'Chapter was successfully created.' }
        format.json { render :json => @chapter, :status => :created, :location => @chapter }
      else
        format.html { render :action => "new" }
        format.json { render :json => @chapter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chapters/1
  # PUT /chapters/1.json
  def update
	@manual = Manual.find(params[:manual_id])
    @chapter = @manual.chapters.find(params[:id])

    respond_to do |format|
      if @chapter.update_attributes(params[:chapter])
        format.html do
			redirect_to({ :action => 'show', :controller => 'manuals', :id => @manual, :anchor => @chapter.chapter_no }, 
				:notice => "Chapter #{@chapter.chapter_no} was successfully updated.")
		end
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @chapter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
	@manual = Manual.find(params[:manual_id])
    @chapter = @manual.chapters.find(params[:id])
    @chapter.destroy

    respond_to do |format|
      format.html { redirect_to manual_chapters_url }
      format.json { head :ok }
    end
  end
end
