(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name angularTreeDiagramApp.controller:MainCtrl
    * @description
    * # MainCtrl
    * Controller of the angularTreeDiagramApp
   */
  angular.module('angularTreeDiagramApp').controller('MainCtrl', function($scope, $firebase) {
    var firebaseObj, req;
    firebaseObj = new Firebase('https://blinding-fire-9153.firebaseio.com');
    req = $firebase(firebaseObj).$asObject();
    req.$loaded().then(function() {
      return $scope.nodes = req;
    });
    return null;
  });

}).call(this);
