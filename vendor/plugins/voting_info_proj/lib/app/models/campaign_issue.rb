class CampaignIssue < ActiveRecord::Base
	belongs_to :source
	belongs_to :election
	has_many :candidate_statements
end
