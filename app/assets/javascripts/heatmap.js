// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var today;
$(document).ready(function () {
  $('#date').datepicker({
    format: "yyyy-mm-dd",
    autoclose: true
  });

  today = new Date();
  var dd = today.getDate();
  var mm = today.getMonth() + 1; // January is 0
  var yyyy = today.getFullYear();

  if (dd < 10) dd = '0' + dd;
  if (mm < 10) mm = '0' + mm;

  today = yyyy + '-' + mm + '-' + dd;

  $('#date').datepicker('update', today)
});

var map;
var heatmap;
var geocoder;
var addressMarker;
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

  // Map
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

  if (location.search !== null) {
    console.log(location.search);
    markAddress(location.search);
  }

  // Set heatmap to today
  $.get( '/heatmap/data?date=' + today, function(data) {
    plotData(data.data)
  });
}

function markAddress(query) {
  geocoder = new google.maps.Geocoder();
  addressMarker = undefined;

  geocoder.geocode( { 'address': unescape(query)}, function(results, status) {
      if (status == 'OK') {
        addressMarker = new google.maps.Marker({
          position: results[0].geometry.location,
          map: map,
          title: 'Your Address'
        });
      } else {
        console.log(status);
        alert('Could not match your address!');
      }
    });
}

function plotData(data) {
  console.log("Plotting...");
  if (data.length === 0) return console.log('No data to plot')

  if (heatmap !== undefined) {
    heatmap.setMap(null)
  }

  var heatMapData = []
  for (var i = 0; i < data.length; i++) {
    var lat = parseFloat(data[i].latitude);
    var lng = parseFloat(data[i].longitude);
    var latLng = {lat: lat, lng: lng};
    var power = parseFloat(data[i].power);

    heatMapData.push({location: new google.maps.LatLng(lat, lng), weight: power});
  }


  heatmap = new google.maps.visualization.HeatmapLayer({
    data: heatMapData
  });

  heatmap.setMap(map);
  console.log("Plotted.");
}

function submitDate(e) {
  e.preventDefault();
  e.stopPropagation()

  $.get( '/heatmap/data?date=' + $("#date").val(), function(data) {
    plotData(data.data)
  });
}
