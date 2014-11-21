'use strict'

describe 'Directive: pane', ->

  # load the directive's module
  beforeEach module 'angularTreeDiagrammApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<pane></pane>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the pane directive'
