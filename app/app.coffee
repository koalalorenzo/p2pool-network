app = angular.module('P2poolNetwork', [ 'ngRoute' ]).config([
  '$routeProvider'
  ($routeProvider) ->
    
    $routeProvider.when('/search',
      templateUrl: 'templates/search.html'
      controller: 'SearchController'
    
    ).when('/nodes/:access',
      templateUrl: 'templates/node.html'
      controller: 'NodeController'
    
    ).otherwise(
      templateUrl: 'templates/index.html'
      controller: ->
    )
    
])