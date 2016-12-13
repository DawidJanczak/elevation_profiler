require('./styles/index.scss')

require('leaflet/dist/leaflet.css')
require('leaflet')

require('./leaflet_icon_hack')

overpass_query = (latlng) ->
  lat = latlng.lat
  lng = latlng.lng
  """
  [out:json];
  way(around:100,#{lat},#{lng})[highway]->.ways;
  node(around:100,#{lat},#{lng})->.nodes;
  .ways >->.way_nodes;
  node.nodes.way_nodes;
  out;
  """

route_params = (from, to) ->
  "from_lat=#{from.lat}&from_lon=#{from.lng}&to_lat=#{to.lat}&to_lon=#{to.lng}"

findClosestTo = (origin, parsed) ->
  minDistance = 1000
  found = null
  for element in parsed.elements
    elemLatLng = new L.LatLng(element.lat, element.lon)
    newDistance = origin.distanceTo(elemLatLng)
    if newDistance < minDistance
      minDistance = newDistance
      found = elemLatLng
  found

drawPath = (from, to) ->
  fetch("/calculate_route?#{route_params(from, to)}")
    .then((response) => response.text())
    .then((body) =>
      debugger
    )

document.addEventListener('DOMContentLoaded', ->
  map = L.map('map').setView([25.1701, 121.6], 15)

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  ).addTo(map)

  prevMarker = null
  map.on('click', (ev) ->
    latlng = ev.latlng
    console.log(latlng)
    fetch("http://overpass-api.de/api/interpreter?data=#{overpass_query(latlng)}")
      .then((response) => response.text())
      .then((body) =>
        found = findClosestTo(latlng, JSON.parse(body))
        if found?
          L.marker(found).addTo(map)
          if prevMarker?
            drawPath(prevMarker, found)
          prevMarker = found
        else
          # TODO: change this to a nice error message
          console.log("no ways next to #{latlng}")
      )
  )
)
