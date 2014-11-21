'use strict';

describe('Controller: TreecontrollerCtrl', function () {

  // load the controller's module
  beforeEach(module('angularTreeDiagrammApp'));

  var TreecontrollerCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    TreecontrollerCtrl = $controller('TreecontrollerCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function () {
    expect(scope.awesomeThings.length).toBe(3);
  });
});
