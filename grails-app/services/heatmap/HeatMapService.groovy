package heatmap

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import geoscript.filter.Filter
import geoscript.geom.Bounds
import geoscript.process.Process as GeoScriptProcess
import geoscript.render.Map as GeoScriptMap
import geoscript.style.ColorMap
import geoscript.workspace.Directory
import geoscript.workspace.Workspace
import static geoscript.style.Symbolizers.*

class HeatMapService
{
  static transactional = false

  enum RenderType {
    BLANK, GEOSCRIPT
  }

  def dataSourceUnproxied

  def getTile(WmsRequest wmsRequest)
  {
    def buffer = new ByteArrayOutputStream()
    def renderType = RenderType.GEOSCRIPT

    switch ( renderType )
    {
    case RenderType.BLANK:
      def image = new BufferedImage( wmsRequest.width, wmsRequest.height, BufferedImage.TYPE_INT_ARGB )
      def type = wmsRequest.format.split( '/' )[-1]

      ImageIO.write( image, type, buffer )
      break
    case RenderType.GEOSCRIPT:
      def postgis = Workspace.getWorkspace(
          dbtype: 'postgis',
          host: '',
          port: '5432',
          user: '',
          password: '',
          database: '',
          "Data Source": dataSourceUnproxied
      )

      try
      {

        def wmsLog = postgis['wms_log']
        def proc = new GeoScriptProcess( "vec:Heatmap" )
        def bounds = wmsRequest.bbox.split( ',' )*.toDouble() as Bounds

        def cursor = wmsLog.getCursor(
            filter: createFilterFromParams( wmsRequest )
        )

        bounds.proj = wmsRequest.srs

        def raster = proc.execute(
            data: cursor,
            radiusPixels: 20,
//    weightAttr: '',
            pixelsPerCell: 1,
            outputBBOX: bounds.env,
            outputWidth: wmsRequest.width,
            outputHeight: wmsRequest.height
        )?.result

        cursor.close()

        raster.style = new ColorMap( [
            [color: "#FFFFFF", quantity: 0, label: "nodata", opacity: 0],
            [color: "#FFFFFF", quantity: 0.02, label: "nodata", opacity: 0],
            [color: "#4444FF", quantity: 0.1, label: "nodata"],
            [color: "#FF0000", quantity: 0.5, label: "values"],
            [color: "#FFFF00", quantity: 1.0, label: "values"]
        ] ).opacity( 0.25 )

        def map = new GeoScriptMap(
            width: wmsRequest.width,
            height: wmsRequest.height,
            type: wmsRequest.format.split( '/' )[-1],
            proj: wmsRequest.srs,
            bounds: bounds,
            layers: [
                raster
            ]
        )

        map.render( buffer )
        map.close()
      }
      catch ( e )
      {
      }

      postgis.close()
      break
    }

    [contentType: wmsRequest.format, buffer: buffer.toByteArray()]
  }

  def getRefTile(WmsRequest wmsRequest)
  {
    def buffer = new ByteArrayOutputStream()
    def renderType = RenderType.GEOSCRIPT

    switch ( renderType )
    {
    case RenderType.BLANK:
      def image = new BufferedImage( wmsRequest.width, wmsRequest.height, BufferedImage.TYPE_INT_ARGB )
      def type = wmsRequest.format.split( '/' )[-1]

      ImageIO.write( image, type, buffer )
      break
    case RenderType.GEOSCRIPT:
      def style = stroke( color: '#00FF00' ) + fill( opacity: 0 )
      def shpDir = new Directory( '/data/omar' )
      def countries = shpDir['world_adm0']
      def states = shpDir['statesp020']

      try
      {

        def bounds = wmsRequest.bbox.split( ',' )*.toDouble() as Bounds

        bounds.proj = wmsRequest.srs
        countries.style = style
        states.style = style

        def map = new GeoScriptMap(
            width: wmsRequest.width,
            height: wmsRequest.height,
            type: wmsRequest.format.split( '/' )[-1],
            proj: wmsRequest.srs,
            bounds: bounds,
            layers: [
                countries, states,
            ]
        )

        map.render( buffer )
        map.close()
      }
      catch ( e )
      {
      }

      shpDir.close()
      break
    }

    [contentType: wmsRequest.format, buffer: buffer.toByteArray()]
  }

  def createFilterFromParams(def params)
  {
    def bounds = ( params.bbox ?: '-180,-90,180,90' ).split( ',' )*.toDouble() as Bounds

    bounds.proj = 'epsg:4326'

    def filter = Filter.bbox( 'geometry', bounds )

    if ( params.start_date )
    {
      filter = filter.and( "end_date >= '${params.start_date}'" )
    }

    if ( params.end_date )
    {
      filter = filter.and( "end_date <= '${params.end_date}'" )
    }

    if ( params.max_gsd )
    {
      filter = filter.and( "mean_gsd <= ${params.max_gsd}" )
    }

    //println filter

    filter
  }
}
