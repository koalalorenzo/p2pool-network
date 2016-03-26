angular.module('P2poolNetwork').controller 'NodeController', [
  '$scope', '$http', '$routeParams',
  ($scope, $http, $routeParams) ->
    $scope.nodes = []
    $scope.ping_value = -1
    $scope.node_access = $routeParams.access
    $scope.node = undefined
    $scope.local_stats = {}

    $scope.node_miners_connected = 0

    $scope.$watch 'nodes', (->
      # Extracting node from the URL provided
      nodes_matching = $scope.nodes.filter (element)->
        $scope.node_access is element.domain + ":" + element.port
      $scope.node = nodes_matching[0]
    ), true

    $scope.$watch 'local_stats', (->
      # When local_stats is update, check the calculate other values like:
      # hashrate, nodes connected etc...
      if $scope.local_stats.miner_hash_rates
        keyz = Object.keys($scope.local_stats.miner_hash_rates)
        $scope.node_miners_connected = keyz.length
      return
    ), true

    $scope.load_nodes = (cb=null) ->
      # Load the nodes available
      $http.get('nodes.json').then ((results) ->
        $scope.nodes = results.data

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
      return if not $scope.node

      $scope.ping($scope.node)

      $scope.first_timer_counter += 1
      if $scope.first_timer_counter >= 9
        clearInterval $scope.first_timer
    ), 1 * 1000)

    # Now checking every 15 seconds.
    $scope.second_timer = setInterval((->
      return if not $scope.node
      $scope.ping($scope.node)
    ), 15 * 1000)
    return
]