angular.module('foodies').controller 'ReviewsController', [
  '$scope'
  '$resource'
  '$location'
  ($scope, $resource, $location) ->
    Review = $resource('/reviews')
    $scope.reviews = Review.query
      method: 'GET'
      page: 1

    $scope.view = (id) ->
      $location.path "/reviews/#{id}"

]

angular.module('foodies').controller 'ReviewsViewController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  'currentUser'
  ($scope, $routeParams, $resource, $location, currentUser) ->
    Review = $resource "/reviews/#{$routeParams.id}.json"
    Review.get (result) ->
      if result.id
        $scope.review = result
      else
        $location.path('/shared/content_not_found')

    currentUser.then (user) ->
      $scope.current_user = user
]

angular.module('foodies').controller 'ReviewsNewController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    $scope.page_title = 'New Review'
    $scope.btn_name = 'Create'

    Review = $resource('/reviews.json')
    $scope.save = ->
      if $scope.form.$valid
        Review.save $scope.review,
        (result) ->
          $location.path("/reviews")
        (err) ->
          console.log err

    $scope.cancel = ->
      $location.path("/reviews")
]

angular.module('foodies').controller 'ReviewsEditController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  '$window'
  ($scope, $routeParams, $resource, $location, $window) ->
    $scope.page_title = 'Edit Review'
    $scope.btn_name = 'Update'
    Review = $resource "/reviews/:id.json",
      {"id": $routeParams.id},
      {"save": "method": "PUT"}

    $scope.review = Review.get()
    $scope.save = ->
      if $scope.form.$valid
        $scope.review.$save (result) ->
          $location.path('/reviews')
        (err) ->
          console.log err

    $scope.cancel = ->
      $window.history.back()
]

angular.module('foodies').controller 'ReviewsDeleteController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    Review = $resource "/reviews/:id.json",
      {"id": $routeParams.id},
      {"delete": "method": "DELETE"}

    $scope.review = Review.get()
    $scope.delete = ->
      $scope.review.$delete (result) ->
        $location.path('/reviews')
      (err) ->
        console.log err


    $scope.cancel = ->
      $location.path("/reviews/#{$routeParams.id}")
]

