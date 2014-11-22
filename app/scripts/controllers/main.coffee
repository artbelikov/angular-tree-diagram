'use strict'

###*
 # @ngdoc function
 # @name angularTreeDiagramApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the angularTreeDiagramApp
###
angular.module('angularTreeDiagramApp')
  .controller 'MainCtrl', ($scope, $firebase) ->
    firebaseObj = new Firebase('https://blinding-fire-9153.firebaseio.com')
    req = $firebase(firebaseObj).$asObject()
    req.$loaded().then(()->
      $scope.nodes = req
    )
    null
