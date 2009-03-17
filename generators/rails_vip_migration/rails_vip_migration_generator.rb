class RailsVipMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', "db/migrate", {:assigns => rails_vip_local_assigns,
        :migration_file_name => "rails_vip_plugin"
       }
    end
  end

  private
#    def custom_file_name
#       custom_name = class_name.tableize
#    end

    def rails_vip_local_assigns
      returning(assigns = {}) do
	assigns[:migration_name] = "RailsVipPlugin"
      end
    end
end
