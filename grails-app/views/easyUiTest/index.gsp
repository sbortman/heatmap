<%--
  Created by IntelliJ IDEA.
  User: sbortman
  Date: 11/25/14
  Time: 11:29 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <asset:stylesheet src="easyUiTest.css"/>
</head>

<body class="easyui-layout">
<div region="north"></div>

<div region="south"></div>

<div region="east" split="true" title=" " collapsed="true" class="eastPanel"></div>

<div region="west" split="true" title=" " collapsed="false" class="westPanel">
    <div class="easyui-panel" title="Query Params" collapsible="true">
        <table class="easyui-propertygrid" showHeader="false" scrollbarSize="0" id="pg"></table>

        <div class="easyui-panel" align="center" style="padding: 5px;">
            <a id="applyButton" href="#" class="easyui-linkbutton" iconCls="icon-ok">Apply</a>
            <a id="resetButton" href="#" class="easyui-linkbutton" iconCls="icon-cancel">Reset</a>
        </div>
    </div>

    <div class="easyui-panel" title="Top Users" collapsible="true">
        <table id="users" class="easyui-datagrid" fitColumns="true" striped="true" pagination="true" rownumbers="true"
               url="${createLink( action: 'getStatsByCategory', params: [category: 'user_name'] )}">
            <thead>
            <tr>
                <th field="user_name">Username</th>
                <th field="count">Count</th>
            </tr>
            </thead>
        </table>
    </div>

    <div class="easyui-panel" title="Top IPs" collapsible="true">
        <table id="ips" class="easyui-datagrid" fitColumns="true" striped="true" pagination="true" rownumbers="true"
               url="${createLink( action: 'getStatsByCategory', params: [category: 'ip'] )}">
            <thead>
            <tr>
                <th field="ip">IP</th>
                <th field="count">Count</th>
            </tr>
            </thead>
        </table>
    </div>

    <div class="easyui-panel" title="Top Layers" collapsible="true">
        <table id="layers" class="easyui-datagrid" fitColumns="true" striped="true" pagination="true" rownumbers="true"
               url="${createLink( action: 'getStatsByCategory', params: [category: 'layers'] )}">
            <thead>
            <tr>
                <th field="layers">Layers</th>
                <th field="count">Count</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<div region="center">
    <div id="map"></div>
</div>

<asset:javascript src="easyUiTest.js"/>
<g:javascript>
    $( document ).ready( function ()
    {
        MapWidget.init();
        Dashboard.init();
//        MapWidget.printParams();
    } );
</g:javascript>
</body>
</html>