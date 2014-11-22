'use strict'
angular.module('angularTreeDiagramApp')
.directive('treeDiagramDirective', ($http)->
  restrict: 'A'
  templateUrl: '/views/tree.html'
  controller: 'MainCtrl'
  transclude: true
  require: 'treeDiagramDirective'
  link: (scope, element) ->
    scope.nodeWidth = 200
    scope.nodeHeight = 100
    scope.viewHeight = element.innerHeight
    scope.zoom = 1
    scope.draggingNode = null
    scope.selectedElements = []
    scope.roots = {}
    scope.maxNodeDisplay = 20
    scope.Math = Math
    scope.treeExpandAll = false
    scope.showModal = false
    scope.treeRootsElements = element[0].querySelector('.tree-roots-elements')
    scope.newNode = (extend)->
      nn =
        id: Math.random() + '-' + Math.random() + '-' + Math.random()
        displayName: 'noname'
        hasChildren: false
        parentId: null
        childrenCount: 0
        childlessCount: 0
      if extend then _.extend(nn,extend)
      return nn
    scope.addNewNode = ()->
      scope.showModal = true
      scope.modalPath = '/views/editFoem.html'
      scope.formNode = scope.newNode()
      null
    scope.editNode = ()->
      scope.showModal = true
      scope.modalPath = '/views/editFoem.html'
      scope.formNode = scope.nodes[document.querySelector('.rect.selected').parentNode.parentNode.getAttribute('id')]
      null
    scope.acceptForm = () ->
      scope.showModal = false
      if !scope.nodes[scope.formNode.id] and !scope.formNode.parentId
        scope.roots[scope.formNode.id] = scope.formNode
      scope.nodes[scope.formNode.id] = scope.formNode
      delete scope.formNode
      null
    scope.cancelForm = ()->
      scope.formNode = {}
      scope.showModal = false
      null
    scope.treeNodeExpand = (id, allowMax) ->
      if (!scope.treeExpandAll)
        if (scope.nodes[scope.nodes[id].parentId])
          for k, obj of scope.nodes[scope.nodes[id].parentId].children
            if (scope.nodes[k].toggle)
              scope.treeNodeCollapse k
        else
          for k, obj of scope.roots
            scope.treeNodeCollapse k
      if !allowMax and scope.nodes[id].childrenCount >= scope.maxNodeDisplay
        scope.nodes['compact' + id] =
          id: 'compact' + id
          displayName: scope.nodes[id].childrenCount + ' nodes hidden'
          compacted: true
          parentId: id
      scope.nodes[id].toggle = true
      null

    scope.treeNodeCollapse = (id) ->
      if (scope.nodes['compact' + id])
        delete scope.nodes['compact' + id]
      scope.nodes[id].toggle = false
      null

    scope.expandAll = () ->
      scope.treeExpandAll = !scope.treeExpandAll
      if (scope.treeExpandAll)
        scope.zoom = 0.5
        scope.treeRootsElements.moved.x = 0
        $('.tree-roots-elements').css(transform:'translate(0px,100px) scale(' + scope.zoom + ')')
        for id, node of scope.nodes
          if scope.nodes[id].hasChildren
            scope.nodes[id].toggle = true
      else
        scope.zoom = 1
        scope.treeRootsElements.moved.x = $('#groups').width()/2 - _.size(scope.treeRoots)*230/2
        $('.tree-roots-elements').css(transform:'translate(' + ($('#groups').width()/2 - _.size(scope.treeRoots)*230/2)  + 'px,100px) scale(' + scope.zoom + ')')
        for id, node of scope.nodes
          if scope.nodes[id].hasChildren
            scope.nodes[id].toggle = false
      null

    scope.toogleNode = (event, id) ->
      if scope.nodes[id].toggle
        scope.treeNodeCollapse id
      else
        scope.treeNodeExpand id
      null

    scope.$on 'NODE_DRAG_START', (event, id)->
      scope.treeNodeCollapse id
      $('.tree-drop-circle:not(.tree-drop-circle'+id+')').addClass 'cshow'
      $('#'+id+' .tree-drop-circle').removeClass 'cshow'
      scope.treeNodeDragging = true
      scope.draggingNode = id
      null
    scope.$on 'NODE_DRAG_END', (event, id)->
      $('.tree-drop-circle').removeClass 'cshow'
      scope.treeNodeDragging = false
      if scope.newParent
        scope.nodes[scope.newParent].children[id] = id:id
        scope.nodes[scope.newParent].hasChildren = true
        if scope.nodes[id].parentId
          delete scope.nodes[scope.nodes[id].parentId].children[id]
        else
          delete scope.roots[id]
        scope.nodes[id].parentId = scope.newParent.id
      scope.draggingNode = null
      null
    scope.treeDropAreaMouseenter = (event,id)->
      scope.newParent = id
      $('.tree-drop-circle'+id).addClass 'h'
      null

    scope.treeDropAreaMouseleave = (event,id)->
      scope.newParent = null
      $('.tree-drop-circle'+id).removeClass 'h'
      null
    scope.$watch 'nodes', (n)->
      if n
        for id, obj of n
          if obj and obj.hasOwnProperty('id') and !obj.parentId
            scope.roots[id] = obj
      null
    null
)

