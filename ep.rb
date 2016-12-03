#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mormon'
require 'ruby_kml'
require 'pry'

osm_file = 'map.osm'
nodes = %w[3167844735 2999412925 2482536143 2482536212]

loader = Mormon::OSM::Loader.new(osm_file)
router = Mormon::OSM::Router.new(loader)

route = nodes.each_cons(2).inject([]) do |result, (node_start, node_end)|
  res = router.find_route(node_start, node_end, :foot)
  raise 'No route found' if res[1].empty?

  result.concat(res[1])
end

# Reverse coords since KML uses <lon,lat> instead of <lat,lon>
placemark = KML::Placemark.new(
  geometry: KML::LineString.new(
    tessellate: true,
    coordinates: route.map(&:reverse)
  )
)

kml = KMLFile.new
doc = KML::Document.new(
  name: 'ElevationProfiler path',
  features: [placemark]
)
kml.objects << doc
File.open('result.kml', 'w') { |f| f.puts(kml.render) }
