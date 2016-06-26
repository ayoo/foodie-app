angular.module('foodies').controller 'AdminUsersController', [
  '$scope'
  '$resource'
  '$location'
  'currentUser'
  ($scope, $resource, $location, currentUser) ->
    User = $resource('/admin/users')
    $scope.users = User.query
      method: 'GET'
      page: 1

    $scope.edit = (id) ->
      $location.path "/admin/users/#{id}/edit"

    currentUser.then (user) ->
      $scope.current_user = user

]

angular.module('foodies').controller 'AdminUsersNewController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    $scope.page_title = 'New User'
    $scope.btn_name = 'Create'

    User = $resource('/admin/users.json')
    $scope.save = ->
      if $scope.form.$valid
        User.save {}, $scope.user,
        (result) ->
          $location.path("/admin/users")
        (err) ->
          console.log err

    $scope.cancel = ->
      $location.path("/admin/users")
]

angular.module('foodies').controller 'AdminUsersEditController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  '$window'
  ($scope, $routeParams, $resource, $location, $window) ->
    $scope.page_title = 'Edit User'
    $scope.btn_name = 'Update'
    User = $resource "/admin/users/:id.json",
      {"id": $routeParams.id},
      {"save": "method": "PUT"}

    $scope.user = User.get()
    $scope.save = ->
      if $scope.form.$valid
        $scope.user.$save (result) ->
          $location.path('/admin/users')
        (err) ->
          console.log err

    $scope.cancel = ->
      $window.history.back()
]

angular.module('foodies').controller 'AdminUsersDeleteController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    User = $resource "/admin/users/:id.json",
      {"id": $routeParams.id},
      {"delete": "method": "DELETE"}

    $scope.user = User.get()
    $scope.delete = ->
      $scope.user.$delete (result) ->
        $location.path('/admin/users')
      (err) ->
        console.log err


    $scope.cancel = ->
      $location.path("/admin/users/#{$routeParams.id}")
]

