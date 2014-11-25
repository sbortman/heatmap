import heatmap.WmsLog

class BootStrap
{

  def wmsLogDataService

  def init = { servletContext ->
    if ( WmsLog.count() == 0 )
    {
      wmsLogDataService.importCsvFile( 'omar_wms_log_data.csv' as File )
    }
  }

  def destroy = {
  }
}
