<!DOCTYPE html>
<html ng-app="app">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>OMAR 2.0 (Tao)</title>

    <asset:stylesheet src="bootStrapTest.css"/>
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" />

    <style type="text/css">
    body { overflow: hidden; }

    .navbar-offset { margin-top: 50px; }
    #map { position: absolute; top: 50px; bottom: 0px; left: 0px; right: 0px; }
    #map .ol-zoom { font-size: 1.2em; }

    .zoom-top-opened-sidebar { margin-top: 5px; }
    .zoom-top-collapsed { margin-top: 45px; }

    .mini-submenu{
        display:none;
        background-color: rgba(255, 255, 255, 0.46);
        border: 1px solid rgba(0, 0, 0, 0.9);
        border-radius: 4px;
        padding: 9px;
        /*position: relative;*/
        width: 42px;
        text-align: center;
    }

    .mini-submenu-left {
        position: absolute;
        top: 60px;
        left: .5em;
        z-index: 40;
    }
    .mini-submenu-right {
        position: absolute;
        top: 60px;
        right: .5em;
        z-index: 40;
    }

    #map { z-index: 35; }

    .sidebar { z-index: 45; }

    .main-row { position: relative; top: 0; }

    .mini-submenu:hover{
        cursor: pointer;
    }

    .slide-submenu{
        background: rgba(0, 0, 0, 0.45);
        display: inline-block;
        padding: 0 8px;
        border-radius: 4px;
        cursor: pointer;
    }
    .panel-group .panel {
        opacity: 0.9;
    }

    #tableLayers {
        table-layout: fixed;
        word-wrap: break-word;
    }

    /*.ng-table {*/
        /*border: 1px solid #ccc;*/
    /*}Í*/


    </style>
   <asset:javascript src="bootStrapTest.js"/>
    <script type="text/javascript">

        function applyMargins() {
            var leftToggler = $(".mini-submenu-left");
            var rightToggler = $(".mini-submenu-right");
            if (leftToggler.is(":visible")) {
                $("#map .ol-zoom")
                        .css("margin-left", 0)
                        .removeClass("zoom-top-opened-sidebar")
                        .addClass("zoom-top-collapsed");
            } else {
                $("#map .ol-zoom")
                        .css("margin-left", $(".sidebar-left").width())
                        .removeClass("zoom-top-opened-sidebar")
                        .removeClass("zoom-top-collapsed");
            }
            if (rightToggler.is(":visible")) {
                $("#map .ol-rotate")
                        .css("margin-right", 0)
                        .removeClass("zoom-top-opened-sidebar")
                        .addClass("zoom-top-collapsed");
            } else {
                $("#map .ol-rotate")
                        .css("margin-right", $(".sidebar-right").width())
                        .removeClass("zoom-top-opened-sidebar")
                        .removeClass("zoom-top-collapsed");
            }
        }

        function isConstrained() {
            return $("div.mid").width() == $(window).width();
        }

        function applyInitialUIState() {
            if (isConstrained()) {
                $(".sidebar-left .sidebar-body").fadeOut('slide');
                $(".sidebar-right .sidebar-body").fadeOut('slide');
                $('.mini-submenu-left').fadeIn();
                $('.mini-submenu-right').fadeIn();
            }
        }

        $(function(){
            $('.sidebar-left .slide-submenu').on('click',function() {
                var thisEl = $(this);
                thisEl.closest('.sidebar-body').fadeOut('slide',function(){
                    $('.mini-submenu-left').fadeIn();
                    applyMargins();
                });
            });

            $('.mini-submenu-left').on('click',function() {
                var thisEl = $(this);
                $('.sidebar-left .sidebar-body').toggle('slide');
                thisEl.hide();
                applyMargins();
            });

            $('.sidebar-right .slide-submenu').on('click',function() {
                var thisEl = $(this);
                thisEl.closest('.sidebar-body').fadeOut('slide',function(){
                    $('.mini-submenu-right').fadeIn();
                    applyMargins();
                });
            });

            $('.mini-submenu-right').on('click',function() {
                var thisEl = $(this);
                $('.sidebar-right .sidebar-body').toggle('slide');
                thisEl.hide();
                applyMargins();
            });

            $(window).on("resize", applyMargins);

            applyInitialUIState();
            applyMargins();
        });
    </script>

</head>
<body ng-controller="MapController" >
<div class="container">
    <nav ng-controller="NavBarController" class="navbar navbar-fixed-top navbar-default" role="navigation">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <img class="pull-left" style="width: 40px; height: 40px; padding-top: 10px;" src="${resource(dir:"images", file:"tao.svg")}" alt="Tao">
                <a class="navbar-brand" href="#">OMAR 2.0 (Tao)</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    %{--<li class="active"><a href="#">Selection</a></li>--}%
                    <li><a href="#"></a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Edit <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Sharpen</a></li>
                            <li><a href="#">Rotate</a></li>
                            <li><a href="#">Brightness</a></li>
                            <li class="divider"></li>
                            <li><a href="#">Screenshot</a></li>
                            <li class="divider"></li>
                            <li><a href="#">E-mail</a></li>
                        </ul>
                    </li>
                </ul>
                <form class="navbar-form navbar-left" role="search">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="Place name search...">
                    </div>
                    <button type="submit" class="btn btn-default">Submit</button>
                </form>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Settings <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Preferences</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Help <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Contact RBT</a></li>
                            <li class="divider"></li>
                            <li><a href="#">About: OMAR v. 2.0</a></li>
                        </ul>
                    </li>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</div>
</nav>
<div class="navbar-offset"></div>
<div id="map"></div>
<div class="row main-row">
    <div class="col-sm-4 col-md-3 sidebar sidebar-left pull-left">

        <div class="panel-group sidebar-body" id="accordion-left">

            <div class="panel panel-default">

                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" href="#layers">
                            <i class="fa fa-list-alt"></i>
                            Layers
                        </a>
                        <span class="pull-right slide-submenu">
                            <i class="fa fa-chevron-left"></i>
                        </span>
                    </h4>
                </div>%{--</ end panel-heading >--}%

                <div ng-controller="LayersPaneController" id="layers" class="panel-collapse collapse in" style="max-height: 475px; overflow-y:scroll;">

                    <div class="panel-group" id="accordion2" role="tablist" aria-multiselectable="true">

                        <div class="panel panel-default">

                            <div class="panel-heading" role="tab" id="headingOneLayers">
                                <h4 class="panel-title">
                                    <a class="collapsed" data-toggle="collapse" data-parent="#accordion2"
                                       href="#collapseOneLayers" aria-expanded="false"
                                       aria-controls="collapseOneLayers">
                                        Add Layer
                                    </a>
                                </h4>
                            </div>%{--</ end headingOneTask >--}%

                            <div id="collapseOneLayers" class="panel-collapse collapse in" role="tabpanel"
                                 aria-labelledby="headingOneLayers">

                                <div class="panel-body" style="max-height: 475px; overflow-y:scroll;">

                                        <form>
                                            <input type="hidden" ng-model="newLayer.id" />
                                            <p><b>WMS Url:</b><br>
                                                <input type="text" ng-model="newLayer.url" /></p>
                                            <p><b>Layers:</b><br>
                                                <input type="text" ng-model="newLayer.params.LAYERS" /></p>
                                            <p><b>Version:</b><br>
                                                <input type="text" ng-model="newLayer.params.VERSION" /></p>
                                            <input type="button" value="Add Layer" ng-click="addLayer()" />
                                        </form>

                                </div>%{--</ end panel-body >--}%

                            </div>%{--</ end headingOneLayers >--}%

                        </div>%{--</ end panel-group >--}%

                        <div class="panel panel-default">

                            <div class="panel-heading" role="tab" id="headingTwoLayers">
                                <h4 class="panel-title">
                                    <a class="collapsed" data-toggle="collapse" data-parent="#accordion2"
                                       href="#collapseTwoLayers" aria-expanded="false"
                                       aria-controls="collapseTwoLayers">
                                        Layer list
                                    </a>
                                </h4>
                            </div>%{--</ end panel-heading >--}%

                            <div id="collapseTwoLayers" class="panel-collapse collapse" role="tabpanel"
                                 aria-labelledby="headingTwoLayers">

                                <div class="panel-body" style="max-height: 475px; overflow-y:scroll;">

                                    <div ng-repeat="layer in layers" style="padding-left: 15px">

                                            <p><b>Id:</b><br>
                                                {{ layer.id }}</p>
                                            <p><b>Url:</b><br>
                                                {{ layer.url }}</p>
                                            <p><b>params.LAYERS:</b><br>
                                                {{ layer.params.LAYERS }}</p>
                                            <p><b>params.VERSION:</b><br>
                                                {{ layer.params.VERSION }}</p>
                                            <p><b>Horizontal Swipe:</b><br>
                                                <input type="range" ng-model="layer.swipe" ng-change="swipe(layer.id)" /></p>
                                            <p><b>Visible:</b><br>
                                                <input type="checkbox" ng-model="layer.visible" ng-change="visible(layer.id)" /></p>
                                            <p><b>opacity:</b><br>
                                                <input type="range" min="0" max="1" step="0.01" ng-model="layer.opacity" ng-change="opacity(layer.id)">
                                            <p><b>Actions:</b><br>
                                                <a href="#" ng-click="edit(layer.id)">edit</a> |
                                                <a href="#" ng-click="delete(layer.id)">delete</a> |
                                                <a href="#" ng-click="addLayerToMap(layer.id)">add</a>

                                    </div>%{--</ end layer in layers >--}%

                                </div>%{--</ end panel-body >--}%

                            </div>%{--</ end collapseTwoLayers >--}%

                        </div>%{--</ end panel panel-default >--}%

                    </div> %{--</ end accordian >--}%

                </div>%{--</ end LayersController >--}%

            </div>%{--</ end panel panel-default >--}%




















        %{--Tools Panel--}%
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" href="#properties">
                            <i class="fa fa-list-alt"></i>
                            Tools
                        </a>
                    </h4>
                </div>
                <div id="properties" class="panel-collapse collapse in">
                    <div class="panel-body">
                        <p ng-controller="ToolsPaneController" class="text-center"></p>
                        <button id="fly" type="button" class="btn btn-primary">Zoom</button>
                        <br/>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-4 col-md-6 mid"></div>
    <div class="col-sm-4 col-md-3 sidebar sidebar-right pull-right">

        %{--Task Panel--}%
        <div class="panel-group sidebar-body" id="accordion-right">
            <div class="panel panel-default">

                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" href="#taskpane">
                            <i class="fa fa-tasks"></i>
                            Task Pane
                        </a>
                        <span class="pull-right slide-submenu">
                            <i class="fa fa-chevron-right"></i>
                        </span>
                    </h4>
                </div>%{--</ end panel-heading >--}%

                <div id="taskpane" class="panel-collapse collapse in">
                    <div class="panel-body">
                       <div ng-controller="TaskPaneController" >

                           <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                               <div class="panel panel-default">

                                   <div class="panel-heading" role="tab" id="headingOneTask">
                                       <h4 class="panel-title">
                                           <a class="collapsed" data-toggle="collapse" data-parent="#accordion"
                                              href="#collapseOneTask" aria-expanded="false"
                                              aria-controls="collapseOneTask">
                                               User and Count
                                           </a>
                                       </h4>
                                   </div>%{--</ end headingOneTask >--}%

                                   <div id="collapseOneTask" class="panel-collapse collapse in" role="tabpanel"
                                        aria-labelledby="headingOneTask">

                                       <div class="panel-body" style="max-height: 475px; overflow-y:scroll;">

                                           %{--<p><strong>Page:</strong> {{tableUsersParams.page()}}--}%
                                           %{--<p><strong>Count per page:</strong> {{tableUsersParams.count()}}--}%

                                           <table class="table table-striped table-condensed" id="mapUserTable">
                                               <thead>
                                               <tr>
                                                   <th>User</th>
                                                   <th>Count</th>
                                               </tr>
                                               </thead>
                                               <tbody>
                                                   <tr ng-repeat="user in mapUsers track by $index">
                                                       <td>{{user.user_name}}</td>
                                                       <td>{{user.count}}</td>
                                                   </tr>
                                               </tbody>
                                           </table>

                                       </div>%{--</ end panel-body >--}%

                                   </div>%{--</ end collapseOneTask >--}%

                               </div>%{--</ end panel panel-default >--}%

                               <div class="panel panel-default">

                                   <div class="panel-heading" role="tab" id="headingTwoTask">
                                       <h4 class="panel-title">
                                           <a class="collapsed" data-toggle="collapse" data-parent="#accordion"
                                              href="#collapseTwoTask" aria-expanded="false"
                                              aria-controls="collapseTwoTask">
                                               IP and Count
                                           </a>
                                       </h4>
                                   </div>%{--</ end headingTwoTask >--}%

                                   <div id="collapseTwoTask" class="panel-collapse collapse" role="tabpanel"
                                        aria-labelledby="headingTwoTask">

                                       <div class="panel-body" style="max-height: 475px; overflow-y:scroll;">

                                           <table class="table table-striped table-condensed">
                                               <tbody>
                                               <th>IP</th>
                                               <th>Count</th>
                                               <tr ng-repeat="ip in mapIps track by $index">
                                                   <td>{{ip.ip}}</td>
                                                   <td>{{ip.count}}</td>
                                               </tr>
                                               </tbody>
                                           </table>

                                       </div>%{--</ end panel-body >--}%

                                   </div>%{--</ end collapseTwoTask >--}%

                               </div>%{--</ end panel panel-default >--}%

                               <div class="panel panel-default">

                                   <div class="panel-heading" role="tab" id="headingThreeTask">
                                       <h4 class="panel-title">
                                           <a class="collapsed" data-toggle="collapse" data-parent="#accordion"
                                              href="#collapseThreeTask" aria-expanded="false"
                                              aria-controls="collapseThreeTask">
                                               Layer and Count
                                           </a>
                                       </h4>
                                   </div>%{--</ end headingThreeTask >--}%

                                   <div id="collapseThreeTask" class="panel-collapse collapse" role="tabpanel"
                                        aria-labelledby="headingThreeTask">

                                       <div class="panel-body" style="max-height: 475px; overflow-y:scroll;">

                                           %{--<p><strong>Page:</strong> {{tableLayersParams.page()}}</p>--}%
                                           %{--<p><strong>Count per page:</strong> {{tableLayersParams.count()}}</p>--}%
                                           <table class="table table-striped table-condensed" id="tableLayers">
                                               <tbody>
                                               <th>Layer</th>
                                               <th>Count</th>
                                               <tr ng-repeat="layer in mapLayers track by $index">
                                                   <td style="font-size: 8px;">{{layer.layers}}</td>
                                                   <td>{{layer.count}}</td>
                                               </tr>
                                               </tbody>
                                           </table>

                                       </div>%{--</ end panel-body >--}%

                                   </div>%{--</ end collapseTwoTask >--}%

                               </div>%{--</ end panel panel-default >--}%

                           </div>%{--</ end panel-group >--}%

                       </div>%{--</ end TaskPaneController >--}%
                    </div>%{--</ end panel-body >--}%
                </div>%{--</ end taskpane >--}%









            </div>
        </div>

    </div>

</div>
<div class="mini-submenu mini-submenu-left pull-left">
    <i class="fa fa-list-alt"></i>
</div>
<div class="mini-submenu mini-submenu-right pull-right">
    <i class="fa fa-tasks"></i>
</div>
</div>
%{--<script type="text/javascript" src="../assets/js/app.js"></script>--}%
</body>
</html>