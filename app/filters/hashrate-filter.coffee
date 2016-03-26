angular.module('P2poolNetwork').filter 'hashrate', ->
  (input) ->
    if input
      # From another p2pool open source library.
      rate = parseFloat(input)
      unit = 'H/s'
      if input >= 1000
        input /= 1000
        unit = 'KH/s'
      if input >= 1000
        input /= 1000
        unit = 'MH/s'
      if input >= 1000
        input /= 1000
        unit = 'GH/s'
      if input >= 1000
        input /= 1000
        unit = 'TH/s'
      if input >= 1000
        input /= 1000
        unit = 'PH/s'
      if input >= 1000
        input /= 1000
        unit = 'EH/s'
      if input >= 1000
        input /= 1000
        unit = 'ZH/s'
      if input >= 1000
        input /= 1000
        unit = 'YH/s'
      rate.toFixed(2) + ' ' + unit
    return "0 H/s"