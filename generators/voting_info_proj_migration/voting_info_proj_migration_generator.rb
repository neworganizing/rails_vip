class VotingInfoProjMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', "db/migrate", {:assigns => voting_info_proj_local_assigns,
        :migration_file_name => "voting_info_proj_plugin"
       }
    end
  end

  private
#    def custom_file_name
#       custom_name = class_name.tableize
#    end

    def voting_info_proj_local_assigns
      returning(assigns = {}) do
	assigns[:migration_name] = "VotingInfoProjPlugin"
      end
    end
end
