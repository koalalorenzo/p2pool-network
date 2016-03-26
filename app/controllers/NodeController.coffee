angular.module('P2poolNetwork').controller 'NodeController', [
  '$scope', '$http', '$routeParams',
  ($scope, $http, $routeParams) ->
    $scope.nodes = []
    $scope.ping_value = -1
    $scope.node_access = $routeParams.access
    $scope.current_node = {}
    $scope.local_stats = {}
        
    $scope.load_nodes = (cb=null) ->
      # Load the nodes available
      $http.get('nodes.json').then ((results) ->
        $scope.nodes = results.data

        # Extracting current_node from the URL provided
        nodes_matching = results.data.filter (element)->
          $scope.node_access is element.domain + ":" + element.port
        $scope.current_node = nodes_matching[0]

        cb() if cb
        return
      ), (data) ->
        console.error data
        return
      return

    $scope.ping = (node) ->
      # "Ping" a Node by making a HTTP call to the local stats and caclulate 
      # the difference of time. Note: this will trigger also the download of
      # the data/stats if the node is new.

      start = new Date().getMilliseconds()
      base_url = 'http://' + node.domain + ':' + node.port + '/local_stats'

      $http.head(base_url).then (a) ->
        end = (new Date).getMilliseconds()
        ping_timed = Math.floor(Math.abs(end - start))

        if $scope.ping_value is -1
          $scope.ping_value = ping_timed
          $scope.download_stats node
        else
          $scope.ping_value = (ping_timed + $scope.ping_value) / 2

    $scope.download_stats = (node) ->
      # "Ping" a Node by making a HTTP call to the local stats and caclulate 
      # the difference of time.
      base_url = 'http://' + node.domain + ':' + node.port + '/local_stats'
      $http.get(base_url).then (out) ->
        $scope.local_stats = out.data

    $scope.load_nodes()
    # Loading the timer that will ping the nodes every sec
    $scope.first_timer_counter = 0
    $scope.first_timer = setInterval((->
      return if not $scope.current_node

      $scope.ping($scope.current_node) 

      $scope.first_timer_counter += 1
      if $scope.first_timer_counter >= 9
        clearInterval $scope.first_timer
    ), 1 * 1000)
 
    # Now checking every 15 seconds.
    $scope.second_timer = setInterval((->
      return if not $scope.current_node
      $scope.ping($scope.current_node) 
    ), 15 * 1000)
    return
]