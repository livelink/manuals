require 'redcloth'
require 'nokogiri'

class ManualsController < ApplicationController
  # GET /manuals
  # GET /manuals.json
  def index
    @manuals = Manual.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @manuals }
    end
  end

  # GET /manuals/1
  # GET /manuals/1.json
  def show
    @manual = Manual.find_by_id(params[:id]) || Manual.find_by_slug(params[:id])

	raise ActiveRecord::RecordNotFound, "No record found for ID=#{params[:id]}" unless @manual

    respond_to do |format|
      format.html do
        # show.html.erb
        if params[:print]
           render :layout => 'print'
        end
      end
      format.pdf {
        File.open(cover=Rails.root.join("tmp/#{@manual.id}.html"), "w") do |fp|
		  fp << <<-EOS
<html>
<head>
<style>
H1 {
	font-size: 36pt;
	margin: 120pt 30pt 0 30pt;
	font-family: Arial;
	text-align: center;
}
blockquote {
	margin: 5pt 30pt 0 30pt;
	font-size: 18pt;
	font-family: Arial;
	text-align: center;
	padding: 0;
}
</style>
</head>
<body>
<h1>#{@manual.title}</h1>
<blockquote>#{CGI.escapeHTML @manual.summary}</blockquote>
</body>
</html>
EOS
        end
        system(Rails.root.join("bin", "wkhtmltopdf-amd64"),
				'--header-center', @manual.title,
				'--header-line',
				'--javascript-delay', '800',
				'--outline-depth', '3',
				'cover', cover,
				'toc', '--xsl-style-sheet', Rails.root.join('data', 'toc.xslt'), 
				url_for(:print => 'yes'),
				out=Rails.root.join("public", "#{@manual.to_param}.pdf"))
         send_file out, :disposition => 'attachment'
      }
      format.json { render :json => @manual }
    end
  end

  # GET /manuals/new
  # GET /manuals/new.json
  def new
    @manual = Manual.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @manual }
    end
  end

  # GET /manuals/1/edit
  def edit
    @manual = Manual.find(params[:id])
  end

  # POST /manuals
  # POST /manuals.json
  def create
    @manual = Manual.new(params[:manual])

    respond_to do |format|
      if @manual.save
        format.html { redirect_to @manual, :notice => 'Manual was successfully created.' }
        format.json { render :json => @manual, :status => :created, :location => @manual }
      else
        format.html { render :action => "new" }
        format.json { render :json => @manual.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manuals/1
  # PUT /manuals/1.json
  def update
    @manual = Manual.find(params[:id])

    respond_to do |format|
      if @manual.update_attributes(params[:manual])
        format.html { redirect_to @manual, :notice => 'Manual was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @manual.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manuals/1
  # DELETE /manuals/1.json
  def destroy
    @manual = Manual.find(params[:id])
    @manual.destroy

    respond_to do |format|
      format.html { redirect_to manuals_url }
      format.json { head :ok }
    end
  end
end
