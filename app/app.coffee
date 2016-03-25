app = angular.module('P2poolNetwork', [ 'ngRoute' ]).config([
  '$routeProvider'
  ($routeProvider) ->
    
    $routeProvider.when('/search',
      templateUrl: 'templates/searchTable'
      controller: 'SearchController'
    
    ).otherwise(
      templateUrl: 'templates/index'
      controller: ->
    )
])