'use strict'
dd = (v...) ->
  console.log v
angular.module('angularTreeDiagramApp')
.directive('treeDiagramDirective', ($http)->
  restrict: 'A'
  templateUrl: '/views/tree.html'
  controller: 'MainCtrl'
  transclude: true
  link: (scope, element) ->
    scope.nodeWidth = 200
    scope.nodeHeight = 100
    scope.viewHeight = element.innerHeight
    scope.zoom = 1
    scope.draggingNode = null
    scope.selectedElements = []
    scope.nodes = {}
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
        children_count: 0
        childless_count: 0
      extend && _.extend(nn,extend)
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
    scope.treeNodeExpand = (id, allow_max = false) ->
      if (!scope.treeExpandAll)
        if (scope.nodes[scope.nodes[id].parentId])
          for k, obj of scope.nodes[scope.nodes[id].parentId].children
            if (scope.nodes[k].toggle)
              scope.treeNodeCollapse k
        else
          for k, obj of scope.roots
            scope.treeNodeCollapse k
      if (!(allow_max || scope.nodes[id].children_count <= scope.maxNodeDisplay))
        scope.nodes['compact' + id] =
          id: 'compact' + id
          displayName: scope.nodes[id].children_count + ' элементов скрыто'
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
          if (scope.nodes[id].hasChildren && !scope.nodes[id].mobsCount)
            scope.nodes[id].toggle = true
      else
        scope.zoom = 1
        scope.treeRootsElements.moved.x = $('#groups').width()/2 - _.size(scope.treeRoots)*230/2
        $('.tree-roots-elements').css(transform:'translate(' + ($('#groups').width()/2 - _.size(scope.treeRoots)*230/2)  + 'px,100px) scale(' + scope.zoom + ')')
        for id, node of scope.nodes
          if (scope.nodes[id].hasChildren && !scope.nodes[id].mobsCount)
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

    $http.get '/data.json'
    .success (data)->
      scope.nodes = data
      for id, obj of data
        if !obj.parentId
          scope.roots[id] = obj
      console.log scope.nodes
      null
    null
)

