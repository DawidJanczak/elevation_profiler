#!/usr/bin/env ruby

require './route_finder'
require './kml_encoder'

osm_file = 'map.osm'
nodes = %w[3167844735 2999412925 2482536143 2482536212 2482536203 3535713750 746292282]

route = RouteFinder.find(osm_file, nodes)
KMLEncoder.encode(route)
