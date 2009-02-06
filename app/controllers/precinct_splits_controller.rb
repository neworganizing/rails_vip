class PrecinctSplitsController < ApplicationController
  # GET /precinct_splits
  # GET /precinct_splits.xml
  def index
    @precinct_splits = PrecinctSplit.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precinct_splits }
    end
  end

  # GET /precinct_splits/1
  # GET /precinct_splits/1.xml
  def show
    @precinct_split = PrecinctSplit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precinct_split }
    end
  end

  # GET /precinct_splits/new
  # GET /precinct_splits/new.xml
  def new
    @precinct_split = PrecinctSplit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precinct_split }
    end
  end

  # GET /precinct_splits/1/edit
  def edit
    @precinct_split = PrecinctSplit.find(params[:id])
  end

  # POST /precinct_splits
  # POST /precinct_splits.xml
  def create
    @precinct_split = PrecinctSplit.new(params[:precinct_split])

    respond_to do |format|
      if @precinct_split.save
        flash[:notice] = 'PrecinctSplit was successfully created.'
        format.html { redirect_to(@precinct_split) }
        format.xml  { render :xml => @precinct_split, :status => :created, :location => @precinct_split }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precinct_split.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /precinct_splits/1
  # PUT /precinct_splits/1.xml
  def update
    @precinct_split = PrecinctSplit.find(params[:id])

    respond_to do |format|
      if @precinct_split.update_attributes(params[:precinct_split])
        flash[:notice] = 'PrecinctSplit was successfully updated.'
        format.html { redirect_to(@precinct_split) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precinct_split.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /precinct_splits/1
  # DELETE /precinct_splits/1.xml
  def destroy
    @precinct_split = PrecinctSplit.find(params[:id])
    @precinct_split.destroy

    respond_to do |format|
      format.html { redirect_to(precinct_splits_url) }
      format.xml  { head :ok }
    end
  end
end
