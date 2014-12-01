package heatmap

import grails.validation.Validateable
import groovy.transform.ToString

/**
 * Created by sbortman on 11/25/14.
 */
@ToString(includeNames = true)
@Validateable
class StatQuery
{
  Integer max
  String startDate
  String endDate
  String bbox
  String category
  Double maxGSD
}
