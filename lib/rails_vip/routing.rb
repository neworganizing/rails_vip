module RailsVip #:nodoc: 
  module Routing #:nodoc:
    module MapperExtensions

      #load controllers for plugin
      def rails_vip
#        @set.add_route("/precinct", {:controller => "precinct", :action => "index"})
#        @set.add_route("/precinct/:action", {:controller => "precinct"})
#        @set.add_route("/precinct/:action/:id", {:controller => "precinct"})
#        @set.add_route("/precinct/:id", {:controller => "precinct", :action => "show"})
#        @set.add_route("/locality", {:controller => "locality", :action => "index"})
#        @set.add_route("/locality/:action", {:controller => "locality"})
#        @set.add_route("/locality/:action/:id", {:controller => "locality"})
#        @set.add_route("/locality/:id", {:controller => "locality", :action => "show"})
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, RailsVip::Routing::MapperExtensions
