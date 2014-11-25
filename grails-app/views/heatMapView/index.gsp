<%--
  Created by IntelliJ IDEA.
  User: sbortman
  Date: 11/24/14
  Time: 9:01 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>HeatMap Viewer</title>
    <meta name="layout" content="main"/>
    <asset:stylesheet src="heatMapView.css"/>
</head>

<body>
<div class="nav">
    <ul>
        <li><g:link class="home" uri="/">Home</g:link></li>
    </ul>
</div>

<div class="content">
    <h1>OMAR Logs HeatMap</h1>

    <div class="mapContainer">
        <div id="map"></div>
    </div>
</div>
<asset:javascript src="heatMapView.js"/>
<g:javascript>
    $( document ).ready( function ()
    {
        init();
    } );
</g:javascript>
</body>
</html>