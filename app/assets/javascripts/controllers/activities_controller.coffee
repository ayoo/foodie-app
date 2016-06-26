angular.module('foodies').controller 'ActivitiesController', [
  '$scope'
  '$resource'
  '$location'
  'currentUser'
  ($scope, $resource, $location, currentUser) ->
    Activity = $resource('/activities.json')

    $scope.activities = Activity.query
      method: 'GET'
      page: 1

    $scope.view = (activity) ->
      $location.path("/#{activity.resource_name}/#{activity.streamable_id}")

    currentUser.then (result) ->
      $scope.current_user = currentUser
]