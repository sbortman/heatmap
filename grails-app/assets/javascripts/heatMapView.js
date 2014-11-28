//= require jquery.js
//= require ol.js
//= require_self

function init()
{
    var layers = [
        new ol.layer.Tile( {
            source: new ol.source.TileWMS( {
                url: 'http://demo.opengeo.org/geoserver/wms',
                params: {
                    LAYERS: 'ne:NE1_HR_LC_SR_W_DR'
                }
            } )
        } ),
        new ol.layer.Tile( {
            source: new ol.source.TileWMS( {
                url: '/heatmap/heatMapView/getTile',
                params: {
                    VERSION: '1.1.1'
                }
            } ),
            extent: ol.extent.buffer( [-180, -90, 180, 90], 0 )
        } )
    ];

    var map = new ol.Map( {
        controls: ol.control.defaults().extend( [
            new ol.control.ScaleLine( {
                units: 'degrees'
            } )
        ] ),
        layers: layers,
        target: 'map',
        view: new ol.View( {
            projection: 'EPSG:4326',
            center: [0, 0],
            zoom: 2
        } )
    } );

    map.on( 'moveend', function ( evt )
    {
        var map = evt.map;
        var extent = map.getView().calculateExtent( map.getSize() );

        console.log( extent );

        ['user_name', 'ip', 'layers'].forEach( function ( category )
        {
            $.ajax( {
                url: '/heatmap/heatMapView/getStatsByCategory',
                data: {
                    category: category,
                    bbox: extent.join( ',' ),
                    max: 10
                },
                success: function ( data )
                {
                    console.log( JSON.stringify( data ) );
                }
            } );
        } );
    } );
}

