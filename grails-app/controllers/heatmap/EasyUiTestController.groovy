package heatmap

import grails.converters.JSON

class EasyUiTestController
{
  def wmsLogDataService

  def index() {}

  def getStatsByCategory()
  {
    def statQuery = new StatQuery(
        category: params.category,
        max: params.int( 'rows' ),
        bbox: params.bbox ?: '-180,-90,180,90',
        startDate: params.startDate,
        endDate: params.endDate,
        maxGSD: params.double( 'maxGSD' )
    )

    def results = wmsLogDataService.getStatsByCategory( statQuery )

//    println params
//    println results

    def data = [
        total: results.size(),
        rows : results
    ]

    render contentType: 'application/json', text:  data as JSON
  }
}
