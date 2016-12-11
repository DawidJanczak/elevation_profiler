require('./styles/index.scss')

require('leaflet/dist/leaflet.css')
require('leaflet')

document.addEventListener('DOMContentLoaded', ->
  map = L.map('map').setView([25.1701, 121.5948], 13)

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  ).addTo(map)

  map.on('click', (ev) ->
    fetch("http://overpass-api.de/api/interpreter?data=[out:json];node[name=\"Gielgen\"];out;")
      .then((response) -> response.text())
      .then((body) -> debugger)
  )
)
