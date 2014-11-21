'use strict'

###*
 # @ngdoc directive
 # @name angularTreeDiagramApp.directive:pane
 # @description
 # # pane
###
angular.module('angularTreeDiagramApp')
  .directive('pane', ->
    restrict: 'A'
    link: (scope, element) ->
      mousewheelevt = if /Firefox/i.test(navigator.userAgent) isnt null then 'DOMMouseScroll' else 'mousewheel'
      scope.inst = Draggable.create(element,
        trigger: '#Tree-Diagram'
      )
      document.querySelector('#Tree-Diagram').onmousewheel = (event)->
        event.preventDefault()
        delta = event.detail || event.wheelDelta
        scope.zoom += delta / 1000
        scope.zoom = Math.min(Math.max(scope.zoom, 0.2),3)
        TweenLite.set(element, {scale:scope.zoom})
      scope.$on 'NODE_DRAG_START', ()->
        scope.inst[0].disable()
        null
      scope.$on 'NODE_DRAG_END', ()->
        scope.inst[0].enable()
        null
      null
  )
