angular.module('P2poolNetwork').controller 'SearchController', [
  '$scope', '$http'
  ($scope, $http) ->
    $scope.nodes = []
    $scope.pings = {}
    $scope.data = {}

    $scope.ping_all = ->
      for i of $scope.nodes
        node = $scope.nodes[i]
        $scope.ping node
      return

    $scope.load_nodes = (cb) ->
      # Load the nodes available
      $http.get('nodes.json').then ((results) ->
        $scope.nodes = results.data
        console.log 'Nodes updated', results.data
        cb()
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

        if not $scope.pings[node.name]
          $scope.pings[node.name] = ping_timed
          $scope.download_stats node
        else
          $scope.pings[node.name] = (ping_timed + $scope.pings[node.name]) / 2

    $scope.download_stats = (node) ->
      # "Ping" a Node by making a HTTP call to the local stats and caclulate 
      # the difference of time.
      base_url = 'http://' + node.domain + ':' + node.port + '/local_stats'
      $http.get(base_url).then (out) ->
        $scope.data[node.name] = out.data

    $scope.load_nodes $scope.ping_all
    # Loading the timer that will ping the nodes every sec
    $scope.first_timer_counter = 0
    $scope.first_timer = setInterval((->
      $scope.ping_all()

      $scope.first_timer_counter += 1
      if $scope.first_timer_counter >= 9
        clearInterval $scope.first_timer
    ), 1 * 1000)
 
    # Now checking every 10 seconds.
    $scope.second_timer = setInterval((->
      $scope.ping_all()
    ), 10 * 1000)
    return
]