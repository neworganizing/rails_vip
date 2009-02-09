class Locality < ActiveRecord::Base
	set_inheritance_column :ruby_type

	belongs_to :source
	belongs_to :election_administration
	belongs_to :state

end
