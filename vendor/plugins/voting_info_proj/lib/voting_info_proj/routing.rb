module VotingInfoProj #:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def voting_info_proj
        @set.add_route("/precinct", {:controller => "precincts_controller", :action => "index"})
        @set.add_route("/precinct/:action", {:controller => "precinct"})
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, VotingInfoProj::Routing::MapperExtensions
