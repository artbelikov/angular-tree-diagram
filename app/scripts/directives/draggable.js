(function() {
  'use strict';

  /**
    * @ngdoc directive
    * @name angularTreeDiagramApp.directive:draggable
    * @description
    * # draggable
   */
  angular.module('angularTreeDiagramApp').directive('draggable', function() {
    return {
      restrict: 'A',
      link: function(scope, element) {
        scope.inst = Draggable.create(element, {
          zIndexBoost: false,
          onClick: function(e) {
            var elem, _i, _len, _ref;
            if (e.ctrlKey) {
              element.toggleClass('selected');
            } else {
              _ref = document.querySelectorAll('.tree-parent .rect');
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                elem = _ref[_i];
                elem.classList.remove('selected');
              }
              element.addClass('selected');
            }
            return null;
          },
          onDragStart: function() {
            scope.$emit('NODE_DRAG_START', scope.element.id);
            element.closest('.tree-parent').addClass('dragging');
            return null;
          },
          onDragEnd: function() {
            scope.$emit('NODE_DRAG_END', scope.element.id);
            element.closest('.tree-parent').removeClass('dragging');
            if (!scope.newParent) {
              TweenLite.set(element, {
                x: 0,
                y: 0
              });
            }
            return null;
          }
        });
        return null;
      }
    };
  });

}).call(this);
