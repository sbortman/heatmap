var app = angular.module('app', [])

app.controller("NavBarController", function ($scope){
	console.log('NavBarController firing!');
	$scope.message = ("This is the NavBarController");
});

app.controller("MapController", function ($scope){
	console.log('MapController firing!');
	$scope.message = ("This is the MapController");
	var baghdad = ol.proj.transform([44.355905,33.311686], 'EPSG:4326', 'EPSG:3857');
	var tehran = ol.proj.transform([51.3498186,35.7014396], 'EPSG:4326', 'EPSG:3857');

	var view = new ol.View({
  		// the view's initial state
  		center: baghdad,
  		zoom: 10
	});

	var map = new ol.Map({
	    target: 'map',
	    renderer: 'canvas',
	    layers: [
			new ol.layer.Tile({
			    opacity: 1.0,
			    source: new ol.source.TileWMS({
					url: 'http://10.0.10.180:8080/geoserver/gwc/service',
		      		params: {'LAYERS': 'osm:omar-basemap_lg', 'TILED': true },
			      	//serverType: 'geoserver'
    			})
			 }),
	    ],
	    view: view
	});

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
	map.beforeRender(pan, bounce);
  		view.setCenter(tehran);
	}, false);

	//Full Screen
	var myFullScreenControl = new ol.control.FullScreen();
	map.addControl(myFullScreenControl);

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




















// canvas example stuff down here	
	// var map = new ol.Map({
	//   layers: [],
	//   renderer: 'canvas',
	//   target: document.getElementById('map'),
	//   view: new ol.View({
	//   	// home --> 28.170904,-80.593862
	//     //center: ol.proj.transform([-74.0064, 40.7142], 'EPSG:4326', 'EPSG:3857'),
	//     center: ol.proj.transform([-80.593862, 28.170904], 'EPSG:4326', 'EPSG:3857'),
	//     maxZoom: 19,
	//     zoom: 14
	//   })
	// });

	//console.log('done firing');
//});

