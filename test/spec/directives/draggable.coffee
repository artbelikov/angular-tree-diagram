'use strict'

describe 'Directive: draggable', ->

  # load the directive's module
  beforeEach module 'angularTreeDiagrammApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<draggable></draggable>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the draggable directive'
