'use strict';

/**
 * @ngdoc overview
 * @name angularTreeDiagramApp
 * @description
 * # angularTreeDiagramApp
 *
 * Main module of the application.
 */
var dd,
  __slice = [].slice;

dd = function() {
  var v;
  v = arguments.length ? __slice.call(arguments, 0) : [];
  return console.log(v);
};
angular
  .module('angularTreeDiagramApp', [
    'ngAnimate',
    'firebase'
  ]);
