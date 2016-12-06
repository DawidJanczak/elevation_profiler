require 'ruby_kml'

class KMLEncoder
  def self.encode(route)
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
  end
end
