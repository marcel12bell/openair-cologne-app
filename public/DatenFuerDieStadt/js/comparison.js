$(function() {

    var influxdb = 'https://openair-api.datacolonia.de/';

    var past = '30d';
    var mean = '12h';

    var sensors = {
        "CA28DB": {name: " Eigelstein, Lübeckerstraße"},
        "F686D9": {name: " Widdersdorf, Blaugasse"},
        "F686D6": {name: " Dellbrück, Krokusweg"},
        "F68654": {name: " Horrem"},
        "F685E9": {name: " Ehrenfeld, Philippstraße" },
        "F686D0": {name: " Nippes" },
        "VKTU": {name: " Offiziell: Neustadt Nord, Turiner Straße"},
        "VKCL": {name: " Offiziell: Mülheim, Clevischer Ring"},
        "RODE": {name: " Offiziell: Rodenkirchen, Friedrich-Ebert-Straße"},
        "CHOR": {name: " Offiziell: Chorweiler, Fühlinger Weg"}

        }

    var testQuery = "SELECT mean(value) FROM open_air..r_co WHERE time > now() - "+past+" AND value > 0 AND (id='F686D0' OR id='F686D6' OR id='F686D9') GROUP BY id,time("+mean+") fill(null)";
    $.getJSON( influxdb, {
                q: testQuery
            },
            function( influxData ) {
                drawGraph(
                        $('#conv_chart'),
                        transformData(influxData),
                        'line'
                );
            }
    );
    var influxdb0 = 'https://138.201.88.0:8086/query?db=db_dust';
    var testQuery0 = "SELECT mean(value) FROM db_dust..NO2_ppm_LANUV WHERE time > now() - "+past+" AND value > 0 AND (wert_in='VKCL' OR wert_in='VKTU' OR wert_in='CHOR' OR wert_in='RODE') GROUP BY wert_in,time("+mean+") fill(null)";
    $.getJSON( influxdb0, {
                q: testQuery0
            },
            function( influxData ) {

                drawGraph(
                        $('#lanuv_chart'),
                        transformDataLanuv(influxData),
                        'line'
                );
            }
    );


    function calculate_nox(r_ox, id) {
    //Derivation_of_the_normal_equations
    //http://www.lauradhamilton.com/tutorial-linear-regression-with-octave
    if (r_ox == null) {
        return null
    }
    if (id[0] == "C") {
        return (-0.00010214 * r_ox + 95.734);
    }else{
        return (-0.000016688 * r_ox + 25.130);

    }
    }

    function transformDataLanuv(influxData) {
        var palette = new Rickshaw.Color.Palette();
        return influxData.results[0].series.map(function(s) {
            return {
                name: sensors[s.tags.wert_in]['name'] + ' (µg/m³)',
                data: s.values.map(function(v) {
                    return { x: new Date(v[0]).getTime() / 1000, y: v[1] };
                }),
                color: palette.color()
            };
        });
    }
    function transformData(influxData) {
        var palette = new Rickshaw.Color.Palette();
        var flip = -1;
        var scale = 100;
        return influxData.results[0].series.map(function(s) {
            return {
                name: sensors[s.tags.id]['name'] + ' (µg/m³)',
                data: s.values.map(function(v) {
                    return { x: new Date(v[0]).getTime() / 1000, y: calculate_nox(v[1],s.tags.id) };
                }),
                color: palette.color()
            };
        });
    }

    function drawGraph($element, series, renderer) {

        var graph = new Rickshaw.Graph({
            element: $element.find('.chart').get(0),
            width: window.innerWidth - window.innerWidth/3,
            height: 270,
            renderer: renderer,
            series: series,
            //interpolation: "linear",
            min: 'auto'
        });

        var yAxis = new Rickshaw.Graph.Axis.Y({
            graph: graph,
            orientation: 'left',
            element: $element.find('.y_axis').get(0),
            //scale: logScale
        });

        var legend = new Rickshaw.Graph.Legend( {
        graph: graph,
        element: document.getElementById('comparison-legend')

        } );

        var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
        graph: graph,
        legend: legend
        } );

        var order = new Rickshaw.Graph.Behavior.Series.Order( {
        graph: graph,
        legend: legend
        } );

        var highlight = new Rickshaw.Graph.Behavior.Series.Highlight( {
        graph: graph,
        legend: legend
        } );

        var hoverDetail = new Rickshaw.Graph.HoverDetail( {
        graph: graph
        } );
        graph.render();
    }

});