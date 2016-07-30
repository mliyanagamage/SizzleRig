function generateMap(root) {
  var width = 800, height = 600;

  var svg = d3.select(root).append("svg")
    .attr("width", width)
    .attr("height", height);

  d3.json("/au.json", function(error, au) {
    if (error) return console.error(error);
    console.log(au);

    var subunits = topojson.feature(au, au.objects.subunits);

    var projection = d3.geo.mercator()
    .translate([width / 2, height / 2])
    .center([133, -27])
    .scale(450);

    var path = d3.geo.path()
      .projection(projection);

    svg.append("path")
      .datum(subunits)
      .attr("d", path);

    svg.selectAll(".subunit")
    .data(topojson.feature(au, au.objects.subunits).features)
    .enter().append("path")
    .attr("class", function(d) { 
      return "subunit " + d.id; 
    })
    .attr("d", path);


    svg.append("path")
    .datum(topojson.mesh(au, au.objects.subunits, function(a, b) { return a !== b; }))
    .attr("d", path)
    .attr("class", "subunit-boundary");

    svg.append("path")
    .datum(topojson.feature(au, au.objects.places))
    .attr("d", path)
    .attr("class", "place");

    svg.selectAll(".place-label")
      .data(topojson.feature(au, au.objects.places).features)
      .enter().append("text")
      .attr("class", "place-label")
      .attr("transform", function(d) { return "translate(" + projection(d.geometry.coordinates) + ")"; })
      .attr("x", function(d) { return d.geometry.coordinates[0] > -1 ? 6 : -6; })
      .attr("dy", ".35em")
      .style("text-anchor", function(d) { return d.geometry.coordinates[0] > -1 ? "start" : "end"; })
      .text(function(d) { return d.properties.name; });

  });
}

