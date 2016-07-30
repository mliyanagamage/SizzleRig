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
      clickableIcons: false
    });

    console.log(map.bounds);

    map.setOptions({styles: styles});

    // Add dummy data
    var myLatLng = {lat: -25.363, lng: 131.044};
    var myLatLng2 = {lat: -26.363, lng: 132.044};
    var myLatLng3 = {lat: -29.363, lng: 135.044};

    map.data.add({geometry: new google.maps.Data.Point(myLatLng)});
    map.data.add({geometry: new google.maps.Data.Point(myLatLng2)});
    map.data.add({geometry: new google.maps.Data.Point(myLatLng3)});
  }
