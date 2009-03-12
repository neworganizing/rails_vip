VotingInfoProj
==============

This plugin will let you use the Voting Information Project's data in your own election information application.  It provides rake tasks for importing source files and models for using the data. Default controllers are not included, though basic ones can be copied from the `Demo app <http://github.com/neworganizing/rails_vip_demo>`_.

Requirements 
------------

* acts_as_tree plugin


getting started
---------------

* Modify routes.rb
   - add the following line


$ map.voting_info_proj

* Use the rake task to import data
   - Example


$ rake vip:parse VIP_URL=http://election-info-standard.googlecode.com/files/sample%20feed%20for%20v1.5.xml RAILS_ENV=production

* Use the plugin's models to display voting information
   - For polling location lookups, use StreetSegment.find_by_address

Future work
-----------
* ignore bad tags, according to spec
* external links
* handle ballot candidate order 


Copyright (c) 2009 New Organizing Institute, released under the MIT license
