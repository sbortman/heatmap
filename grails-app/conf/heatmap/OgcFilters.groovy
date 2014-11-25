package heatmap

class OgcFilters
{

  def filters = {

    ogc( controller: 'heatMapView', action: 'getTile' ) {
      before = {
        WmsRequest.metaClass.properties.each {
          def caps = it.name.toUpperCase()
          if ( params.containsKey( caps ) )
          {
            params[it.name] = params[caps]
            params.remove( caps )
          }
        }
      }
    }

    all( controller: '*', action: '*' ) {
      before = {

      }
      after = { Map model ->

      }
      afterView = { Exception e ->

      }
    }
  }
}
