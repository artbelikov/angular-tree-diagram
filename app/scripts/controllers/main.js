(function() {
  'use strict';

  /**
    * @ngdoc function
    * @name angularTreeDiagramApp.controller:MainCtrl
    * @description
    * # MainCtrl
    * Controller of the angularTreeDiagramApp
   */

  /*jshint shadow: true */
  var MainCtrl,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MainCtrl = (function() {
    MainCtrl.$inject = ['$scope', '$firebase'];

    function MainCtrl(scope, firebase) {
      var firebaseObj, req;
      this.scope = scope;
      this.firebase = firebase;
      this.removeNode = __bind(this.removeNode, this);
      this.editNode = __bind(this.editNode, this);
      this.addNode = __bind(this.addNode, this);
      firebaseObj = new Firebase('https://blinding-fire-9153.firebaseio.com');
      req = this.firebase(firebaseObj).$asObject();
      req.$bindTo(this.scope, 'nodes');
      this.scope.addNode = this.addNode;
      this.scope.editNode = this.addNode;
      this.scope.removeNode = this.addNode;
    }

    MainCtrl.prototype.addNode = function(node) {
      return this.scope.nodes.$add(node);
    };

    MainCtrl.prototype.editNode = function(id) {
      return this.scope.nodes.$save(id);
    };

    MainCtrl.prototype.removeNode = function(id) {
      return this.scope.nodes.$remove(id);
    };

    return MainCtrl;

  })();

  angular.module('angularTreeDiagramApp').controller('MainCtrl', MainCtrl);

}).call(this);
