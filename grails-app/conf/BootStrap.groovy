import heatmap.WmsLog
import groovy.sql.Sql

class BootStrap
{
  def dataSource

  def wmsLogDataService

  def init = { servletContext ->
    if ( WmsLog.count() == 0 )
    {
      wmsLogDataService.importCsvFile( 'omar_wms_log_data.csv' as File )
    }

    def sql = new Sql( dataSource )

    sql.execute( "DROP INDEX IF EXISTS  wms_log_geometry_idx" )
    sql.execute( "CREATE INDEX wms_log_geometry_idx ON wms_log USING gist (geometry)" )
    sql.close()
  }

  def destroy = {
  }
}
