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
                    <li class="active"><a href="#">Selection</a></li>
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
                        <input type="text" class="form-control" placeholder="Enter Coordinates...">
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
                </div>
                <div id="layers" class="panel-collapse collapse in">
                    <p ng-controller="LayersPaneController" class="text-center"></p>
                    <div class="panel-body list-group">
                        <a href="#" class="list-group-item">
                            <i class="fa fa-globe"></i> Reference Map
                        </a>
                        <a href="#" class="list-group-item">
                            <i class="fa fa-globe"></i> Imagery
                        </a>
                        <a href="#" class="list-group-item">
                            <i class="fa fa-globe"></i> WMS
                        </a>
                    </div>
                </div>
            </div>
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
                </div>
                <div id="taskpane" class="panel-collapse collapse in">
                    <div class="panel-body">
                       <div ng-controller="TaskPaneController" >
                           %{--<div ng-controller="AccordionDemoCtrl">--}%
                               %{--<p>--}%
                                   %{--<button class="btn btn-default btn-sm" ng-click="status.open = !status.open">Toggle last panel</button>--}%
                                   %{--<button class="btn btn-default btn-sm" ng-click="status.isFirstDisabled = ! status.isFirstDisabled">Enable / Disable first panel</button>--}%
                               %{--</p>--}%

                               %{--<label class="checkbox">--}%
                                   %{--<input type="checkbox" ng-model="oneAtATime">--}%
                                   %{--Open only one at a time--}%
                               %{--</label>--}%
                               %{--<accordion close-others="oneAtATime">--}%
                                   %{--<accordion-group heading="Static Header, initially expanded" is-open="status.isFirstOpen" is-disabled="status.isFirstDisabled">--}%
                                       %{--This content is straight in the template.--}%
                                   %{--</accordion-group>--}%
                                   %{--<accordion-group heading="{{group.title}}" ng-repeat="group in groups">--}%
                                       %{--{{group.content}}--}%
                                   %{--</accordion-group>--}%
                                   %{--<accordion-group heading="Dynamic Body Content">--}%
                                       %{--<p>The body of the accordion group grows to fit the contents</p>--}%
                                       %{--<button class="btn btn-default btn-sm" ng-click="addItem()">Add Item</button>--}%
                                       %{--<div ng-repeat="item in items">{{item}}</div>--}%
                                   %{--</accordion-group>--}%
                                   %{--<accordion-group is-open="status.open">--}%
                                       %{--<accordion-heading>--}%
                                           %{--I can have markup, too! <i class="pull-right glyphicon" ng-class="{'glyphicon-chevron-down': status.open, 'glyphicon-chevron-right': !status.open}"></i>--}%
                                       %{--</accordion-heading>--}%
                                       %{--This is just some content to illustrate fancy headings.--}%
                                   %{--</accordion-group>--}%
                               %{--</accordion>--}%
                           %{--</div>--}%

                           <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                               <div class="panel panel-default">
                                   <div class="panel-heading" role="tab" id="headingOne">
                                       <h4 class="panel-title">
                                           <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                               Map Extent
                                           </a>
                                       </h4>
                                   </div>
                                   <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                       <div class="panel-body">
                                           <p>Min X: {{extent[0]}}</p>
                                           <p>Min Y: {{extent[1]}}</p>
                                           <p>Max X: {{extent[2]}}</p>
                                           <p>Max Y: {{extent[3]}}</p>
                                       </div>
                                   </div>
                               </div>
                               <div class="panel panel-default">
                                   <div class="panel-heading" role="tab" id="headingTwo">
                                       <h4 class="panel-title">
                                           <a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                               User and Count
                                           </a>
                                       </h4>
                                   </div>
                                   <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                       <div class="panel-body">
                                           <table class="table table-striped">
                                               <tbody>
                                               <th>User</th>
                                               <th>Count</th>
                                               <tr ng-repeat="user in mapUser track by $index">
                                                   <td>{{user.user_name}}</td>
                                                   <td>{{user.count}}</td>
                                               </tr>
                                               </tbody>
                                           </table>
                                       </div>
                                   </div>
                               </div>
                               <div class="panel panel-default">
                                   <div class="panel-heading" role="tab" id="headingThree">
                                       <h4 class="panel-title">
                                           <a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                               IP and Count
                                           </a>
                                       </h4>
                                   </div>
                                   <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                                       <div class="panel-body">
                                           <table class="table table-striped">
                                               <tbody>
                                               <th>IP</th>
                                               <th>Count</th>
                                               <tr ng-repeat="ip in mapIp track by $index">
                                                   <td>{{ip.ip}}</td>
                                                   <td>{{ip.count}}</td>
                                               </tr>
                                               </tbody>
                                           </table>
                                       </div>
                                   </div>
                               </div>
                           </div>






                       </div>
                    </div>
                </div>
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