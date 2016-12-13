# Leaflet icon hack (https://github.com/Leaflet/Leaflet/issues/4968)
icon = require('leaflet/dist/images/marker-icon.png')
iconShadow = require('leaflet/dist/images/marker-shadow.png')
DefaultIcon = L.icon(
  iconUrl: icon
  shadowUrl: iconShadow
  iconSize: [25, 41]
  iconAnchor: [12, 41]
)
L.Marker.prototype.options.icon = DefaultIcon
