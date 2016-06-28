angular.module('foodies').controller 'BlogsController', [
  '$scope'
  '$resource'
  '$location'
  ($scope, $resource, $location) ->
    Blog = $resource('/blogs')
    $scope.blogs = Blog.query
      method: 'GET'
      page: 1

    $scope.view = (id) ->
      $location.path "/blogs/#{id}"

]

angular.module('foodies').controller 'BlogsViewController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  'currentUser'
  ($scope, $routeParams, $resource, $location, currentUser) ->
    Blog = $resource "/blogs/#{$routeParams.id}.json"
    result = Blog.get().$promise
    result.then (result) -> $scope.blog = result
    .catch (err) -> $location.path('/shared/content_not_found')

    currentUser.then (user) ->
      $scope.current_user = user

]

angular.module('foodies').controller 'BlogsNewController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    $scope.page_title = 'New Blog'
    $scope.btn_name = 'Create'

    Blog = $resource('/blogs.json')
    $scope.save = ->
      if $scope.form.$valid
        Blog.save $scope.blog,
        (result) ->
          $location.path("/blogs")
        (err) ->
          console.log err

    $scope.cancel = ->
      $location.path("/blogs")
]

angular.module('foodies').controller 'BlogsEditController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  '$window'
  ($scope, $routeParams, $resource, $location, $window) ->
    $scope.page_title = 'Edit Blog'
    $scope.btn_name = 'Update'
    Blog = $resource "/blogs/:id.json",
                      {"id": $routeParams.id},
                      {"save": "method": "PUT"}

    $scope.blog = Blog.get()
    $scope.save = ->
      if $scope.form.$valid
        $scope.blog.$save (result) ->
          $location.path('/blogs')
        (err) ->
          console.log err

    $scope.cancel = ->
      $window.history.back()
]

angular.module('foodies').controller 'BlogsDeleteController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    Blog = $resource "/blogs/:id.json",
                    {"id": $routeParams.id},
                    {"delete": "method": "DELETE"}

    $scope.blog = Blog.get()
    $scope.delete = ->
      $scope.blog.$delete (result) ->
        $location.path('/blogs')
      (err) ->
        console.log err


    $scope.cancel = ->
      $location.path("/blogs/#{$routeParams.id}")
]

