class SourceController < ApplicationController
	layout 'layouts/main'
	def show 
		@source = Source.find(params[:id])
	end
	def index
		@sources = Source.find(:all)
	end
end
