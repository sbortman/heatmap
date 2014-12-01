package heatmap

import grails.converters.JSON

class HeatMapViewController
{
  def heatMapService
  def wmsLogDataService

  def index() {}

  def getTile(WmsRequest wmsRequest)
  {
    //println params
    //println wmsRequest

    def results = heatMapService.getTile( wmsRequest )

    render contentType: results.contentType, file: results.buffer
  }

  def getRefTile(WmsRequest wmsRequest)
  {
    //println params
    //println wmsRequest

    def results = heatMapService.getRefTile( wmsRequest )

    render contentType: results.contentType, file: results.buffer
  }


  def getStatsByCategory(StatQuery query)
  {
    println query

    def results = wmsLogDataService.getStatsByCategory( query )

    render contentType: 'application/json', text: results as JSON
  }
}
