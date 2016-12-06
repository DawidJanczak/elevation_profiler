require 'mormon'

class RouteFinder
  def self.find(map_file, nodes)
    loader = Mormon::OSM::Loader.new(osm_file)
    router = Mormon::OSM::Router.new(loader)

    nodes.each_cons(2).inject([]) do |result, (node_start, node_end)|
      res = router.find_route(node_start, node_end, :foot)
      raise 'No route found' if res[1].empty?

      result.concat(res[1])
    end
  end
end
