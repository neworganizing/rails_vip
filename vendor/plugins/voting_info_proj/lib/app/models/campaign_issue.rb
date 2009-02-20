class CampaignIssue < ActiveRecord::Base
	belongs_to :source
	belongs_to :election
	has_many :candidate_statements
	has_many :custom_notes, :as => :object
end
