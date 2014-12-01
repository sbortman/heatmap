/**
 * Created by sbortman on 11/25/14.
 */

//= require jquery.js
//= require jeasyui/jquery.easyui.min.js
//= require ol.js
//= require_self

MapWidget = (function ()
{
    var theMap = null,
        theLayers = null,
        theView = null,
        theHeatMapLayer = null;

    theHeatMapLayer = new ol.layer.Tile( {
        source: new ol.source.TileWMS( {
            url: '/heatmap/heatMapView/getTile',
            params: {
                VERSION: '1.1.1'
            }
        } ),
        extent: ol.extent.buffer( [-180, -90, 180, 90], 0 )
    } );


    return {
        init: function ()
        {
            theLayers = [
                new ol.layer.Tile( {
                    source: new ol.source.TileWMS( {
                        url: 'http://demo.opengeo.org/geoserver/wms',
                        params: {
                            'LAYERS': 'ne:NE1_HR_LC_SR_W_DR'
                        }
                    } ),
                    extent: ol.extent.buffer( [-180, -90, 180, 90], 0 )
                } ),
                new ol.layer.Tile( {
                    source: new ol.source.TileWMS( {
                        url: '/heatmap/heatMapView/getRefTile',
                        params: {
                            VERSION: '1.1.1'
                        }
                    } ),
                    extent: ol.extent.buffer( [-180, -90, 180, 90], 0 )
                } ),
                theHeatMapLayer
            ];

            theView = new ol.View( {
                projection: 'EPSG:4326',
                center: [0, 0],
                zoom: 1,
                maxResolution: 0.703125
            } );

            theMap = new ol.Map( {
                controls: ol.control.defaults().extend( [
                    new ol.control.ScaleLine( {
                        units: 'degrees'
                    } ),
                    //new ol.control.MousePosition( {
                    //    coordinateFormat: ol.coordinate.createStringXY( 4 ),
                    //    projection: 'EPSG:4326',
                    //    // comment the following two lines to have the mouse position
                    //    // be placed within the map.
                    //    className: 'custom-mouse-position',
                    //    target: document.getElementById( 'mouse-position' ),
                    //    undefinedHTML: '&nbsp;'
                    //} ),
                    new ol.control.Rotate()
                ] ),
                layers: theLayers,
                target: 'map',
                view: theView
            } );

            theMap.on( 'moveend', function ( evt )
            {
                var map = evt.map;
                var extent = map.getView().calculateExtent( map.getSize() );

                Dashboard.updateBbox( extent );
            } );
        },
        updateSize: function ()
        {
            theMap.updateSize();
        },
        updateHeatMapParams: function ( newParams )
        {
            theHeatMapLayer.getSource().updateParams( newParams );

                /*
                 var curParams = heatMapLayer.getSource().getParams();

                 for ( var k in newParams )
                 {
                 curParams[k] = newParams[k];
                 }
                 */

            //console.log( theHeatMapLayer.getSource().getParams() );
        }
    };
})();

Dashboard = (function ()
{
    var theBBOX = null,
        theStartDate = null,
        theEndDate = null,
        theMaxGSD = null,
        theFilterParams = [{
            name: 'Start Date', editor: 'datetimebox'
        }, {
            name: 'End Date', editor: 'datetimebox'
        }, {
            name: 'Max GSD', editor: 'text'
        }];

    function refresh()
    {
        var params = {};

        if ( theBBOX )
        {
            params.bbox = theBBOX;
        }

        if ( theStartDate )
        {
            params.startDate = theStartDate;
        }

        if ( theEndDate )
        {
            params.endDate = theEndDate;
        }

        if ( theMaxGSD )
        {
            params.maxGSD = theMaxGSD;
        }

        //console.log( params );

        ['#users', '#ips', '#layers'].forEach( function ( tableId )
        {
            $( tableId ).datagrid( {
                queryParams: params
            } );
        } );

        MapWidget.updateHeatMapParams( {
            bbox: theBBOX,
            start_date: theStartDate,
            end_date: theEndDate,
            max_gsd: theMaxGSD
        } );
    }

    return {
        init: function ()
        {
            $( '#pg' ).propertygrid( {
                data: {
                    total: theFilterParams.length,
                    rows: theFilterParams
                }
            } );

            $( '#applyButton' ).click( function ()
            {
                var data = $( '#pg' ).propertygrid( 'getData' ).rows;

                data.forEach( function ( row )
                {
                    if ( row.value )
                    {
                        if ( row.name === 'Start Date' )
                        {
                            theStartDate = row.value;
                        }
                        else if ( row.name === 'End Date' )
                        {
                            theEndDate = row.value;
                        }
                        else if ( row.name === 'Max GSD' )
                        {
                            theMaxGSD = row.value;
                        }
                    }
                } );

                refresh();
            } );

            $( '#resetButton' ).click( function ()
            {
                theFilterParams.forEach( function ( row )
                {
                    row.value = null;
                } );

                $( '#pg' ).propertygrid( {
                    data: theFilterParams

                } );

                theStartDate = null;
                theEndDate = null;
                theMaxGSD = null;
                refresh();
            } );

        },
        updateBbox: function ( extent )
        {
            theBBOX = extent.join( ',' );
            //console.log( extent );
            refresh();
        }
    };
})();