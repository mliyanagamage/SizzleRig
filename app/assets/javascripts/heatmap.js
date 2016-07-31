// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var map;
var styles = [
  {
    "stylers": [
      { "visibility": "simplified" }
    ]
  },{
    "featureType": "administrative",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "landscape.man_made",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "road",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "transit",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "water",
    "stylers": [
      { "color": "#ffffff" }
    ]
  },{
    "featureType": "landscape.natural",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#808080" }
    ]
  }
]

function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: -28, lng: 132},
    zoom: 4,
    maxZoom: 4,
    minZoom:4,
    disableDefaultUI: true,
    keyboardShortcuts: false,
    draggable: false,
    scrollwheel: false,
    clickableIcons: false
  });

  map.setOptions({styles: styles});

  var today = new Date();
  var dd = today.getDate();
  var mm = today.getMonth() + 1; //January is 0!
  var yyyy = today.getFullYear();

  if (dd < 10) dd = '0' + dd;
  if (mm < 10) mm = '0' + mm;

  today = yyyy + '-' + mm + '-' + dd; // USE TODAY!!
  $.get( '/heatmap/data?date=' + '2004-10-04', function(data) {
    plotData(data.data)
  });

  map.data.setStyle({
    icon: {
      url: "http://localhost:3000/red.png",
    }
  })
}

function plotData(data) {
  console.log("Plotting...");
  if (data.length === 0) return console.log('No data to plot')

  for (var i = 0; i < data.length; i++) {
    var lat = parseFloat(data[i].latitude);
    var lng = parseFloat(data[i].longitude);
    var power = parseFloat(data[i].power);
    var latLng = {lat: lat, lng: lng};

    map.data.add({geometry: new google.maps.Data.Point(latLng)});
  }

  console.log("Plotted.");
}
