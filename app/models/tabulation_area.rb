class TabulationArea < ActiveRecord::Base
	acts_as_tree
 	set_inheritance_column :ruby_type  #this just lets us have a column named 'type'
	belongs_to :source
	belongs_to :statewide_state, :class_name => 'State'
	has_and_belongs_to_many :precincts
	has_and_belongs_to_many :precinct_splits
	has_and_belongs_to_many :localities
	has_many :tabulation_areas
	has_many :contests

	def tabulation_areas
		self.children
	end

	def state
		self.statewide_state	
	end
	def state=(newstate)
		self.statewide_state = newstate 
	end
end
