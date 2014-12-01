var app = angular.module('app', ['ngTable'])

app.factory("mapDataFactory", function ($http, $cacheFactory){

	return{
		getMapInfo : function(category, extent) {
			return $http({
				//url: '/heatmap/heatMapView/getStatsByCategory?category=user_name&bbox=-216.73828125%2C-70.48828125%2C216.73828125%2C70.48828125&max=10',
				//url: '/heatmap/heatMapView/getStatsByCategory?category=user_name&bbox=' + extent + ' &max=10',
				url: '/heatmap/heatMapView/getStatsByCategory?category=' + category + '&' + 'bbox=' + extent + ' &max=100',
				method: 'GET'
			})
		}
	}

});

app.controller("MapController", function ($scope, mapDataFactory ){

	console.log('MapController firing!');
	$scope.message = ("This is the MapController");
	//var baghdad = ol.proj.transform([44.355905,33.311686], 'EPSG:4326', 'EPSG:3857');
	var baghdad = [44.355905,33.311686];
	var tehran = [51.3498186,35.7014396];

	var view = new ol.View({
  		// the view's initial state
  		//center: baghdad,
  		//zoom: 10
		projection: 'EPSG:4326',
		center: baghdad,
		zoom: 3
	});

	$scope.map = new ol.Map({
	    target: 'map',
	    renderer: 'canvas',
	    layers: [
			new ol.layer.Tile({
			    opacity: 1.0,
			    source: new ol.source.TileWMS({
					url: 'http://localhost:8080/geoserver/gwc/service',
		      		params: {'LAYERS': 'osm:omar-basemap_lg', 'TILED': true },
			      	//serverType: 'geoserver'
    			})
			 }),
			new ol.layer.Tile( {
				source: new ol.source.TileWMS( {
					url: '/heatmap/heatMapView/getTile',
					params: {
						VERSION: '1.1.1'
					}
				} ),
				extent: ol.extent.buffer( [-180, -90, 180, 90], 0 )
			})
	    ],
	    view: view
	});

	$scope.map.on( 'moveend', function ( evt ){

		$scope.map = evt.map;
		$scope.extent = $scope.map.getView().calculateExtent( $scope.map.getSize() );

		//console.log($scope.extent = $scope.map.getView().calculateExtent( $scope.map.getSize() ));
		$scope.extentAll = $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3];
		$scope.extentMinX = $scope.extent[0];
		$scope.extentMinY = $scope.extent[1];
		$scope.extentMaxX = $scope.extent[2];
		$scope.extentMaxY = $scope.extent[3];

		$scope.mapUser = [];
		mapDataFactory.getMapInfo('user_name', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
			$scope.mapUser=data;
			console.log($scope.mapUser=data);

		});

		$scope.mapIp = [];
		mapDataFactory.getMapInfo('ip', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
			$scope.mapIp=data;
		});

		$scope.mapLayers = [];
		mapDataFactory.getMapInfo('layers', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
			$scope.mapLayers=data;
			//console.log($scope.mapLayers);
		});

		//['user_name', 'ip', 'layers'].forEach( function ( category )
		//['user_name'].forEach( function ( category )
		//{
		//	$.ajax( {
		//		url: '/heatmap/heatMapView/getStatsByCategory',
		//		data: {
		//			category: category,
		//			bbox: $scope.extent.join( ',' ),
		//			max: 10
		//		},
		//		success: function ( data )
		//		{
		//			//console.log( JSON.stringify( data ) );
		//		}
		//	} );
		//} );
	} );

	var fly = document.getElementById('fly');
	fly.addEventListener('click', function() {
		var duration = 2000;
		var start = +new Date();
		var pan = ol.animation.pan({
			duration: duration,
			source: /** @type {ol.Coordinate} */ (view.getCenter()),
			start: start
  	});
  	var bounce = ol.animation.bounce({
    	duration: duration,
    	resolution: 4 * view.getResolution(),
    	start: start
  	});
	$scope.map.beforeRender(pan, bounce);
  		view.setCenter(tehran);
	}, false);

	//Full Screen
	var myFullScreenControl = new ol.control.FullScreen();
	$scope.map.addControl(myFullScreenControl);

});

app.controller("LayersPaneController", function ($scope){
	console.log('LayersPaneController firing!');
	$scope.message = ("This is the LayersPaneController");
});

app.controller("ToolsPaneController", function ($scope){
	console.log('ToolsPaneController firing!');
	$scope.message = ("This is the ToolsPaneController");
});

app.controller("TaskPaneController", function ($scope){
	console.log('TaskPaneController firing!');
	$scope.message = ("This is the TaskPaneController");
});

app.controller("NavBarController", function ($scope){
	console.log('NavBarController firing!');
	$scope.message = ("This is the NavBarController");
});

app.controller('AccordionDemoCtrl', function ($scope) {
	$scope.oneAtATime = true;

	$scope.groups = [
		{
			title: 'Dynamic Group Header - 1',
			content: 'Dynamic Group Body - 1'
		},
		{
			title: 'Dynamic Group Header - 2',
			content: 'Dynamic Group Body - 2'
		}
	];

	$scope.items = ['Item 1', 'Item 2', 'Item 3'];

	$scope.addItem = function() {
		var newItemNo = $scope.items.length + 1;
		$scope.items.push('Item ' + newItemNo);
	};

	$scope.status = {
		isFirstOpen: true,
		isFirstDisabled: false
	};
});














