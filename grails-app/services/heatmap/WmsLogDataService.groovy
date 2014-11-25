package heatmap

import au.com.bytecode.opencsv.CSVReader
import geoscript.geom.Bounds
import groovy.sql.Sql
import geoscript.geom.io.WkbReader


import grails.transaction.Transactional

@Transactional
class WmsLogDataService
{
  def static final insertRecordSQL = """
INSERT INTO wms_log (
    bbox, end_date, format, geometry, height, internal_time, ip, layers, mean_gsd,
    render_time, request, start_date, styles, total_time, url, user_name, width
) VALUES (
    :bbox, :end_date, :format, ST_GeometryFromText(:geometry, 4326), :height, :internal_time, :ip, :layers, :mean_gsd,
    :render_time, :request, :start_date, :styles, :total_time, :url, :user_name, :width
);
"""

  def dataSourceUnproxied

  def importCsvFile(def csvFile)
  {
    def reader = new CSVReader( csvFile.newReader() )
    def count = 0
    def batchSize = 100
    def header = null
    def record = null

    def sql = new Sql( dataSourceUnproxied )
    def wkbReader = new WkbReader()
    def start = System.currentTimeMillis()

    sql.withBatch( batchSize, insertRecordSQL ) { ps ->
      while ( ( record = reader.readNext() ) != null )
      {
        if ( header )
        {
          assert header.size() == record.size()
          def params = ( 0..<header.size() ).inject( [:] ) { a, b -> a[header[b]] = record[b]; a }

          //println params

          params['end_date'] = parseTimestamp( params['end_date'] )
          params['geometry'] = wkbReader.read( params['geometry'] ).wkt
          params['height'] = params['height'].toInteger()
          params['internal_time'] = params['internal_time'].toDouble()
          params['mean_gsd'] = params['mean_gsd'].toDouble()
          params['render_time'] = params['render_time'].toDouble()
          params['start_date'] = parseTimestamp( params['start_date'] )
          params['total_time'] = params['total_time'].toDouble()
          params['width'] = params['width'].toInteger()

          try
          {
            ps.addBatch( params )
          }
          catch ( e )
          {
            println e?.message
            println e?.nextException?.message
          }

          count++;
        }
        else
        {
          header = record
        }
      }
    }

    sql.commit()
    sql?.close()

    def stop = System.currentTimeMillis()

    println "elapsed: ${( stop - start ) / 1000}s"
    println "count: ${count}"

  }

  private def parseTimestamp(def input)
  {
    def dateFormats = [
        'yyyy-MM-dd hh:mm:ss.SSS',
        'yyyy-MM-dd hh:mm:ss',
    ]

    def output
    def lastException

    for ( format in dateFormats )
    {
      try
      {
        output = Date.parse( format, input ).toTimestamp()
      }
      catch ( e )
      {
        lastException = e
      }

      if ( output )
      {
        break
      }
    }

    if ( !output )
    {
      throw lastException
    }

    return output
  }

  def getStatsByCategory(StatQuery query)
  {
    def sql = new Sql( dataSourceUnproxied )
    def bbox = query.bbox.split( ',' )*.toDouble() as Bounds
    def params = [max: query.max, wkt: bbox.polygon.wkt]

    def where = """
    ST_Intersects(geometry, ST_GeometryFromText(:wkt, 4326))
    """

    if ( query.startDate )
    {
      where += " AND end_date >= :startDate"
      params.startDate = parseTimestamp( query.startDate )
    }

    if ( query.endDate )
    {
      where += " AND end_date <= :endDate"
      params.endDate = parseTimestamp( query.endDate )
    }

    def topSQL = """
    SELECT ${query.category}, count(*) as count
    FROM wms_log
    WHERE ${where}
    GROUP BY ${query.category}
    ORDER BY count DESC
    LIMIT :max
    """

    def results = sql.rows( topSQL, params )

    sql?.close()

    results
  }
}






