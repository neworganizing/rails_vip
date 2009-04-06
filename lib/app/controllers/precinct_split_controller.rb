class PrecinctSplitsController < ApplicationController

  def index
    @precinct_splits = PrecinctSplit.find(:all)
  end

  def show
    @precinct_split = PrecinctSplit.find(params[:id])

  end

end
