'use strict';

describe('Directive: TreeDiagrammDirective', function () {

  // load the directive's module
  beforeEach(module('angularTreeDiagrammApp'));

  var element,
    scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should make hidden element visible', inject(function ($compile) {
    element = angular.element('<-tree-diagramm-directive></-tree-diagramm-directive>');
    element = $compile(element)(scope);
    expect(element.text()).toBe('this is the TreeDiagrammDirective directive');
  }));
});
