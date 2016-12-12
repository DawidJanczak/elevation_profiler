require('./styles/index.scss')

require('leaflet/dist/leaflet.css')
require('leaflet')

# Leaflet icon hack (https://github.com/Leaflet/Leaflet/issues/4968)
icon = require('leaflet/dist/images/marker-icon.png')
iconShadow = require('leaflet/dist/images/marker-shadow.png')
DefaultIcon = L.icon(
  iconUrl: icon,
  shadowUrl: iconShadow
)
L.Marker.prototype.options.icon = DefaultIcon

overpass_query = (latlng) ->
  lat = latlng.lat
  lng = latlng.lng
  """
  [out:json];
  way(around:100,#{lat},#{lng})->.ways;
  node(around:100,#{lat},#{lng})->.nodes;
  .ways >->.way_nodes;
  node.nodes.way_nodes;
  out;
  """

findClosestTo = (origin, parsed) ->
  minDistance = 1000
  found = null
  for element in parsed.elements
    elemLatLng = new L.LatLng(element.lat, element.lon)
    if origin.distanceTo(elemLatLng) < minDistance
      found = elemLatLng
  found

document.addEventListener('DOMContentLoaded', ->
  map = L.map('map').setView([25.1701, 121.5948], 13)

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  ).addTo(map)

  map.on('click', (ev) ->
    latlng = ev.latlng
    # TODO: handle no nodes returned
    fetch("http://overpass-api.de/api/interpreter?data=#{overpass_query(latlng)}")
      .then((response) => response.text())
      .then((body) =>
        found = findClosestTo(latlng, JSON.parse(body))
        L.marker(found).addTo(map)
      )
  )
)
