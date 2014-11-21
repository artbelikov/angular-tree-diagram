'use strict'

###*
 # @ngdoc directive
 # @name angularTreeDiagramApp.directive:draggable
 # @description
 # # draggable
###
angular.module('angularTreeDiagramApp')
  .directive('draggable', ->
    restrict: 'A'
    link: (scope, element) ->
      scope.inst = Draggable.create(element,
        zIndexBoost:false
        onClick: (e)->
          if e.ctrlKey
            element.toggleClass('selected')
          else
            for elem in document.querySelectorAll('.tree-parent .rect')
              elem.classList.remove('selected')
            element.addClass('selected')
          null
        onDragStart:()->
          scope.$emit 'NODE_DRAG_START', scope.element.id
          element.closest('.tree-parent').addClass 'dragging'
          null
        onDragEnd:()->
          scope.$emit 'NODE_DRAG_END', scope.element.id
          element.closest('.tree-parent').removeClass 'dragging'
          if !scope.newParent
            TweenLite.set(element,{x:0, y:0})
          null

      )
      null
  )
