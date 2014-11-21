(function() {
  'use strict';

  /**
    * @ngdoc directive
    * @name angularTreeDiagramApp.directive:pane
    * @description
    * # pane
   */
  angular.module('angularTreeDiagramApp').directive('pane', function() {
    return {
      restrict: 'A',
      link: function(scope, element) {
        var mousewheelevt, _ref;
        mousewheelevt = (_ref = /Firefox/i.test(navigator.userAgent)) != null ? _ref : {
          "DOMMouseScroll": "mousewheel"
        };
        scope.inst = Draggable.create(element, {
          trigger: '#Tree-Diagram'
        });
        document.querySelector('#Tree-Diagram').onmousewheel = function(event) {
          var delta;
          event.preventDefault();
          delta = event.detail || event.wheelDelta;
          scope.zoom += delta / 1000;
          scope.zoom = Math.min(Math.max(scope.zoom, 0.2), 3);
          return TweenLite.set(element, {
            scale: scope.zoom
          });
        };
        scope.$on('NODE_DRAG_START', function(event, id) {
          scope.inst[0].disable();
          return null;
        });
        return scope.$on('NODE_DRAG_END', function(event, id) {
          scope.inst[0].enable();
          return null;
        });
      }
    };
  });

}).call(this);
