package heatmap

import grails.converters.JSON

class BootStrapTestController
{

  def wmsLogDataService
  def getWMSInfoByLayerId(String layerId){
    render contentType: 'application/json',
            text: wmsLogDataService.getWMSInfoByLayerId(layerId) as JSON
  }
  def index() {}
}
