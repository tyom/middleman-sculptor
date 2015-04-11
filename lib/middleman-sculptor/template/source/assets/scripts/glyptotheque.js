//= require_tree ./glyptotheque

angular.module('glyptotheque', ['directives', 'controllers', 'services']);

iFrameResize({
  enablePublicMethods: true,
  heightCalculationMethod: 'lowestElement'
});
