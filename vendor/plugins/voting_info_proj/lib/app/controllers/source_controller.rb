class SourceController < ApplicationController
	layout 'layouts/main'
	def index
		@sources = Source.find(:all, :conditions => "active = 1")
	end
	def show 
		@source = Source.find(params[:id])
	end
end
