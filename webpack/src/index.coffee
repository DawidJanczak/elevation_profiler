require('./styles/index.scss')

require('leaflet/dist/leaflet.css')
require('leaflet')

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
    fetch("http://overpass-api.de/api/interpreter?data=[out:json];node(around:100,#{latlng.lat},#{latlng.lng});out;")
      .then((response) => response.text())
      .then((body) =>
        found = findClosestTo(latlng, JSON.parse(body))
        L.marker(found).addTo(map)
      )
  )
)
