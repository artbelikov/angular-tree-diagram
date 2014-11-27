(function() {
  'use strict';
  angular.module('angularTreeDiagramApp').directive('treeDiagramDirective', function() {
    return {
      restrict: 'A',
      templateUrl: './views/tree.html',
      controller: 'MainCtrl',
      transclude: true,
      require: 'treeDiagramDirective',
      link: function(scope, element) {
        scope.nodeWidth = 200;
        scope.nodeHeight = 100;
        scope.viewHeight = element.innerHeight;
        scope.zoom = 1;
        scope.draggingNode = null;
        scope.selectedElements = [];
        scope.roots = {};
        scope.maxNodeDisplay = 20;
        scope.Math = Math;
        scope.treeExpandAll = false;
        scope.showModal = false;
        scope.treeRootsElements = element[0].querySelector('.tree-roots-elements');
        scope.newNode = function(extend) {
          var nn;
          nn = {
            id: Math.random() + '-' + Math.random() + '-' + Math.random(),
            displayName: 'noname',
            hasChildren: false,
            parentId: null,
            childrenCount: 0,
            childlessCount: 0
          };
          if (extend) {
            _.extend(nn, extend);
          }
          return nn;
        };
        scope.addNewNode = function() {
          scope.showModal = true;
          scope.modalPath = './views/editForm.html';
          scope.formNode = scope.newNode();
          return null;
        };
        scope.editNode = function() {
          scope.showModal = true;
          scope.modalPath = './views/editForm.html';
          scope.formNode = scope.nodes[document.querySelector('.rect.selected').parentNode.parentNode.getAttribute('id')];
          return null;
        };
        scope.acceptForm = function() {
          scope.showModal = false;
          if (!scope.nodes[scope.formNode.id] && !scope.formNode.parentId) {
            scope.roots[scope.formNode.id] = scope.formNode;
          }
          scope.nodes[scope.formNode.id] = scope.formNode;
          delete scope.formNode;
          return null;
        };
        scope.cancelForm = function() {
          scope.formNode = {};
          scope.showModal = false;
          return null;
        };
        scope.treeNodeExpand = function(id, allowMax) {
          var k, obj, _ref, _ref1;
          if (!scope.treeExpandAll) {
            if (scope.nodes[scope.nodes[id].parentId]) {
              _ref = scope.nodes[scope.nodes[id].parentId].children;
              for (k in _ref) {
                obj = _ref[k];
                if (scope.nodes[k].toggle) {
                  scope.treeNodeCollapse(k);
                }
              }
            } else {
              _ref1 = scope.roots;
              for (k in _ref1) {
                obj = _ref1[k];
                scope.treeNodeCollapse(k);
              }
            }
          }
          if (!allowMax && scope.nodes[id].childrenCount >= scope.maxNodeDisplay) {
            scope.nodes['compact' + id] = {
              id: 'compact' + id,
              displayName: scope.nodes[id].childrenCount + ' nodes hidden',
              compacted: true,
              parentId: id
            };
          }
          scope.nodes[id].toggle = true;
          return null;
        };
        scope.treeNodeCollapse = function(id) {
          if (scope.nodes['compact' + id]) {
            delete scope.nodes['compact' + id];
          }
          scope.nodes[id].toggle = false;
          return null;
        };
        scope.expandAll = function() {
          var id, node, _ref, _ref1;
          scope.treeExpandAll = !scope.treeExpandAll;
          if (scope.treeExpandAll) {
            scope.zoom = 0.5;
            scope.treeRootsElements.moved.x = 0;
            $('.tree-roots-elements').css({
              transform: 'translate(0px,100px) scale(' + scope.zoom + ')'
            });
            _ref = scope.nodes;
            for (id in _ref) {
              node = _ref[id];
              if (scope.nodes[id].hasChildren) {
                scope.nodes[id].toggle = true;
              }
            }
          } else {
            scope.zoom = 1;
            scope.treeRootsElements.moved.x = $('#groups').width() / 2 - _.size(scope.treeRoots) * 230 / 2;
            $('.tree-roots-elements').css({
              transform: 'translate(' + ($('#groups').width() / 2 - _.size(scope.treeRoots) * 230 / 2) + 'px,100px) scale(' + scope.zoom + ')'
            });
            _ref1 = scope.nodes;
            for (id in _ref1) {
              node = _ref1[id];
              if (scope.nodes[id].hasChildren) {
                scope.nodes[id].toggle = false;
              }
            }
          }
          return null;
        };
        scope.toogleNode = function(event, id) {
          if (scope.nodes[id].toggle) {
            scope.treeNodeCollapse(id);
          } else {
            scope.treeNodeExpand(id);
          }
          return null;
        };
        scope.$on('NODE_DRAG_START', function(event, id) {
          scope.treeNodeCollapse(id);
          $('.tree-drop-circle:not(.tree-drop-circle' + id + ')').addClass('cshow');
          $('#' + id + ' .tree-drop-circle').removeClass('cshow');
          scope.treeNodeDragging = true;
          scope.draggingNode = id;
          return null;
        });
        scope.$on('NODE_DRAG_END', function(event, id) {
          $('.tree-drop-circle').removeClass('cshow');
          scope.treeNodeDragging = false;
          if (scope.newParent) {
            scope.nodes[scope.newParent].children[id] = {
              id: id
            };
            scope.nodes[scope.newParent].hasChildren = true;
            if (scope.nodes[id].parentId) {
              delete scope.nodes[scope.nodes[id].parentId].children[id];
            } else {
              delete scope.roots[id];
            }
            scope.nodes[id].parentId = scope.newParent.id;
          }
          scope.draggingNode = null;
          return null;
        });
        scope.treeDropAreaMouseenter = function(event, id) {
          scope.newParent = id;
          $('.tree-drop-circle' + id).addClass('h');
          return null;
        };
        scope.treeDropAreaMouseleave = function(event, id) {
          scope.newParent = null;
          $('.tree-drop-circle' + id).removeClass('h');
          return null;
        };
        scope.$watch('nodes', function(n) {
          var id, obj;
          if (n) {
            for (id in n) {
              obj = n[id];
              if (obj && obj.hasOwnProperty('id') && !obj.parentId) {
                scope.roots[id] = obj;
              }
            }
          }
          return null;
        });
        return null;
      }
    };
  });

}).call(this);
