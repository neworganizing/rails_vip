class TabulationArea < ActiveRecord::Base
	acts_as_tree
 	set_inheritance_column :ruby_type  #this just lets us have a column named 'type'
	belongs_to :source
	belongs_to :statewide_state, :class_name => 'State'
	has_and_belongs_to_many :precincts
	has_and_belongs_to_many :precinct_splits
	has_and_belongs_to_many :localities
	has_many :tabulation_areas, :through => "tabulation_areas"
        belongs_to :tabulation_areas, :foreign_key => "parent"
	has_many :contests
	has_many :custom_notes, :as => :object
	alias_attribute :state, :statewide_state

	def tabulation_areas
		self.children
	end

	# get all tabulation areas below this one
	def all_children
		self.children + self.children.each {|c| c.all_children}.collect
	end

	# get all tabulation areas above this one
	def parents
		self.parent.nil? ? [] : [self.parent] + self.parent.parents
	end
end
