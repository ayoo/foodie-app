angular.module('foodies').factory 'currentUser', [
  '$resource'
  '$rootScope'
  ($resource, $rootScope) ->
    if not $rootScope.current_user
      Session = $resource('/current_session')
      $rootScope.current_user = Session.get()

    $rootScope.current_user.$promise
]