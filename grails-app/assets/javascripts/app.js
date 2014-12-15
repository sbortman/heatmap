var app = angular.module('app', ['ngTable'])

app.factory("mapDataFactory", function ($http, $cacheFactory){

	return{
		getMapInfo : function(category, extent) {
			return $http({
				//url: '/heatmap/heatMapView/getStatsByCategory?category=user_name&bbox=-216.73828125%2C-70.48828125%2C216.73828125%2C70.48828125&max=10',
				//url: '/heatmap/heatMapView/getStatsByCategory?category=user_name&bbox=' + extent + ' &max=10',
				url: '/heatmap/heatMapView/getStatsByCategory?category=' + category + '&' + 'bbox=' + extent + ' &max=100',
				method: 'GET'
			});
		}
	}

});

app.controller("MapController", function ($scope, mapDataFactory, $timeout, ngTableParams ){

	//console.log('MapController firing!');
	//$scope.message = ("This is the MapController");

	//var baghdad = ol.proj.transform([44.355905,33.311686], 'EPSG:4326', 'EPSG:3857');
	var baghdad = [44.355905,33.311686];
	var tehran = [51.3498186,35.7014396];
	var tampaBay = [-82.5719968,27.7670005]

	var view = new ol.View({
  		// the view's initial state
		projection: 'EPSG:4326',
		center: tampaBay,
		zoom: 10
	});

	var scaleLineControl = new ol.control.ScaleLine();

	$scope.map = new ol.Map({
		controls: ol.control.defaults({
			attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
				collapsible: false
			})
		}).extend([
			scaleLineControl
		]),
		interactions: ol.interaction.defaults().extend([
			new ol.interaction.DragRotateAndZoom()
		]),
	    target: 'map',
	    renderer: 'canvas',
	    layers: [
			new ol.layer.Tile({
			    opacity: 1.0,
			    source: new ol.source.TileWMS({
					url: 'http://localhost:8080/geoserver/gwc/service',
		      		params: {'LAYERS': 'osm:omar-basemap_lg', 'TILED': true }
			      	//serverType: 'geoserver'
    			})
			 }),
			new ol.layer.Tile( {
				source: new ol.source.TileWMS( {
					url: 'http://localhost:9999/heatmap/heatMapView/getTile',
					params: {
						VERSION: '1.1.1'
					}
				}),
				extent: ol.extent.buffer( [-180, -90, 180, 90], 0 )
			}),
			//new ol.layer.Tile({
			//	opacity: 0.3,
			//	source: new ol.source.TileWMS({
			//		url: 'http://192.168.0.145:8080/omar/ogc/wms',
			//		params: {'LAYERS': '22', 'VERSION': '1.1.1', 'FORMAT': 'image/jpeg'}
			//	})
            //
			//})
	    ],
	    view: view
	});

	$scope.map.on( 'moveend', function ( evt ){

		$scope.map = evt.map;
		$scope.extent = $scope.map.getView().calculateExtent( $scope.map.getSize() );

		//console.log($scope.extent = $scope.map.getView().calculateExtent( $scope.map.getSize() ));
		//$scope.extentAll = $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3];
		$scope.extentMinX = $scope.extent[0];
		$scope.extentMinY = $scope.extent[1];
		$scope.extentMaxX = $scope.extent[2];
		$scope.extentMaxY = $scope.extent[3];

		$scope.mapUser = [];
		mapDataFactory.getMapInfo('user_name', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
			$scope.mapUsers=data;
			//console.log($scope.mapUsers=data);
		});
		//$('#mapUserTable').DataTable();

		$scope.mapIps = [];
		mapDataFactory.getMapInfo('ip', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
			$scope.mapIps=data;
			//console.log($scope.mapIps)
		});

		$scope.mapLayers = [];
		mapDataFactory.getMapInfo('layers', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
			$scope.mapLayers=data;
			//console.log($scope.mapLayers);
		});

		//$scope.mapUser = [];
		//mapDataFactory.getMapInfo('user_name', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
        //
		//	//$scope.mapUser = data;
		//	//$scope.uniqueUsers = data.length;
		//	console.log('Unique users:' + $scope.uniqueUsers);
        //
		//	$scope.tableUsersParams = new ngTableParams({
		//		page: 1,            // show first page
		//		count: 5           // count per page
		//	}, {
		//		total: data.length, // length of data
		//		getData: function($defer, params) {
		//			$defer.resolve(data.slice((params.page() - 1) * params.count(), params.page() * params.count()));
        //
		//		}
		//	});
        //
		//});

		//$scope.mapIp = [];
		//mapDataFactory.getMapInfo('ip', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
        //
		//	//$scope.mapIp=data;
		//	//$scope.uniqueIps = data.length;
        //
		//	$scope.tableIpsParams = new ngTableParams({
		//		page: 1,            // show first page
		//		count: 5           // count per page
		//	}, {
		//		total: data.length, // length of data
		//		getData: function($defer, params) {
		//			$defer.resolve(data.slice((params.page() - 1) * params.count(), params.page() * params.count()));
		//		}
		//	});
		//	console.log('mapIp firing...');
		//});

		//$scope.mapLayers = [];
		//mapDataFactory.getMapInfo('layers', $scope.extent[0] + ',' + $scope.extent[1] + ',' + $scope.extent[2] + ',' + $scope.extent[3]).success(function(data){
        //
        //
		//	$scope.tableLayersParams = new ngTableParams({
		//		page: 1,            // show first page
		//		count: 5           // count per page
		//	}, {
		//		total: data.length, // length of data
		//		getData: function($defer, params) {
		//			$defer.resolve(data.slice((params.page() - 1) * params.count(), params.page() * params.count()));
		//		}
		//	});
		//	console.log('mapLayers firing...');
		//});

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
	//$scope.message = ("This is the LayersPaneController");

	var uid = 1;

	$scope.newLayer = { // defaults
		'url': 'http://omar.ossim.org/omar/ogc/wms',
		'params': {
			'LAYERS': '49', // for testing (Tampa Bay area)
			'VERSION': '1.1.1'
		}
	}

	//$scope.mapParams = {
	//	'center': {
	//		'lat': 33.46247641750577,
	//		'lon': 44.36451439868474,
	//		'zoom': 10
	//	}
	//}

	$scope.layers = [
		{
			'id': 0,
			'url': 'http://omar.ossim.org/omar/ogc/wms',
			'params': {
				'LAYERS': '49',
				'VERSION': '1.1.1'
			},
			'swipe': '',
			'visible': true,
			'opacity': 1
		}
	];

	$scope.layer = [];

	$scope.addLayerToMap = function(id) {
		$scope.layer[id] = new ol.layer.Image({
			source: new ol.source.ImageWMS({
				url: $scope.layers[id].url,
				params: {
					LAYERS: $scope.layers[id].params.LAYERS,
					VERSION: $scope.layers[id].params.VERSION
				}
			})
		});

		$scope.layers[id].opacity = 1;
		$scope.layers[id].visible = true;
		$scope.map.addLayer($scope.layer[id]);
	}

	$scope.swipe = function(id) {
		$scope.layer[id].on('precompose', function(event) {
			var ctx = event.context;
			var width = ctx.canvas.width * ($scope.layers[id].swipe / 100);

			ctx.save();
			ctx.beginPath();
			ctx.rect(width, 0, ctx.canvas.width - width, ctx.canvas.height);
			ctx.clip();
		});

		$scope.layer[id].on('postcompose', function(event) {
			var ctx = event.context;
			ctx.restore();
		});

		$scope.map.render();
	}

	$scope.visible = function(id) {
		$scope.layer[id].setVisible($scope.layers[id].visible);
	}

	$scope.opacity = function(id) {
		$scope.layer[id].setOpacity($scope.layers[id].opacity);
	}

	$scope.removeLayerFromMap = function(id) {
		$scope.map.removeLayer($scope.layer[id]);
	}

	$scope.delete = function(id) {
		//search layer with given id and delete it
		for(i in $scope.layers) {
			if($scope.layers[i].id == id) {
				$scope.layers.splice(i,1);
				$scope.newLayer = {};

				$scope.removeLayerFromMap(id);
			}
		}
	}

	$scope.addLayer = function() {
		console.log('firing addLayer!');
		if($scope.newLayer.id == null) {
			//if this is new layer, add it in layers array
			$scope.newLayer.id = uid++;
			$scope.layers.push($scope.newLayer);

			$scope.addLayerToMap($scope.newLayer.id);
		}

		else {
			//for existing layer, find this layer using id
			//and update it.
			for(i in $scope.layers) {
				if($scope.layers[i].id == $scope.newLayer.id) {
					$scope.layers[i] = $scope.newLayer;

					$scope.removeLayerFromMap($scope.newLayer.id);
					$scope.addLayerToMap($scope.newLayer.id);
				}
			}
		}

		//clear the add layer form
		$scope.newLayer = {};
	}

	$scope.edit = function(id) {
		//search layer with given id and update it
		for(i in $scope.layers) {
			if($scope.layers[i].id == id) {
				//we use angular.copy() method to create
				//copy of original object
				$scope.newLayer = angular.copy($scope.layers[i]);
			}
		}
	}


});

app.controller("ToolsPaneController", function ($scope){
	//console.log('ToolsPaneController firing!');
	//$scope.message = ("This is the ToolsPaneController");
});

app.controller("TaskPaneController", function ($scope){
	//console.log('TaskPaneController firing!');
	//$scope.message = ("This is the TaskPaneController");
});

app.controller("NavBarController", function ($scope){
	//console.log('NavBarController firing!');
	//$scope.message = ("This is the NavBarController");
});

//TODO: Wire this up to the Accordian for IPs, Users, and Layers
//app.controller('AccordionDemoCtrl', function ($scope) {
//	$scope.oneAtATime = true;
//
//	$scope.groups = [
//		{
//			title: 'Dynamic Group Header - 1',
//			content: 'Dynamic Group Body - 1'
//		},
//		{
//			title: 'Dynamic Group Header - 2',
//			content: 'Dynamic Group Body - 2'
//		}
//	];
//
//	$scope.items = ['Item 1', 'Item 2', 'Item 3'];
//
//	$scope.addItem = function() {
//		var newItemNo = $scope.items.length + 1;
//		$scope.items.push('Item ' + newItemNo);
//	};
//
//	$scope.status = {
//		isFirstOpen: true,
//		isFirstDisabled: false
//	};
//});














