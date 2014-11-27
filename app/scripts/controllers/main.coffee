'use strict'

###*
 # @ngdoc function
 # @name angularTreeDiagramApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the angularTreeDiagramApp
###
###jshint shadow: true###
class MainCtrl
  @$inject: ['$scope', '$firebase']
  constructor: (@scope, @firebase) ->
    firebaseObj = new Firebase('https://blinding-fire-9153.firebaseio.com')
    req = @firebase(firebaseObj).$asObject()
    req.$bindTo(@scope, 'nodes')
    @scope.addNode = @addNode
    @scope.editNode = @addNode
    @scope.removeNode = @addNode

  addNode: (node)=>
    @scope.nodes.$add(node)
  editNode: (id)=>
    @scope.nodes.$save(id)
  removeNode: (id)=>
    @scope.nodes.$remove(id)

angular.module('angularTreeDiagramApp').controller 'MainCtrl', MainCtrl
