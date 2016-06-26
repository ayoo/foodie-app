angular.module('foodies').controller 'RecipesController', [
  '$scope'
  '$resource'
  '$location'
  ($scope, $resource, $location) ->
    Recipe = $resource('/recipes')
    $scope.recipes = Recipe.query
      method: 'GET'
      page: 1

    $scope.view = (id) ->
      $location.path "/recipes/#{id}"
]

angular.module('foodies').controller 'RecipesViewController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  'currentUser'
  ($scope, $routeParams, $resource, $location, currentUser) ->
    Recipe = $resource "/recipes/#{$routeParams.id}.json"
    Recipe.get (result) ->
      if result.id
        $scope.recipe = result
      else
        $location.path('/shared/content_not_found')

    currentUser.then (user) ->
      $scope.current_user = user
]

angular.module('foodies').controller 'RecipesNewController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    $scope.page_title = 'New Recipe'
    $scope.btn_name = 'Create'

    Recipe = $resource('/recipes.json')
    $scope.save = ->
      if $scope.form.$valid
        Recipe.save $scope.recipe,
        (result) ->
          $location.path("/recipes")
        (err) ->
          console.log err

    $scope.cancel = ->
      $location.path("/recipes")
]

angular.module('foodies').controller 'RecipesEditController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  '$window'
  ($scope, $routeParams, $resource, $location, $window) ->
    $scope.page_title = 'Edit Recipe'
    $scope.btn_name = 'Update'
    Recipe = $resource "/recipes/:id.json",
      {"id": $routeParams.id},
      {"save": "method": "PUT"}

    $scope.recipe = Recipe.get()
    $scope.save = ->
      if $scope.form.$valid
        $scope.recipe.$save (result) ->
          $location.path('/recipes')
        (err) ->
          console.log err

    $scope.cancel = ->
      $window.history.back()
]

angular.module('foodies').controller 'RecipesDeleteController', [
  '$scope'
  '$routeParams'
  '$resource'
  '$location'
  ($scope, $routeParams, $resource, $location) ->
    Recipe = $resource "/recipes/:id.json",
      {"id": $routeParams.id},
      {"delete": "method": "DELETE"}

    $scope.recipe = Recipe.get()
    $scope.delete = ->
      $scope.recipe.$delete (result) ->
        $location.path('/recipes')
      (err) ->
        console.log err

    $scope.cancel = ->
      $location.path("/recipes/#{$routeParams.id}")
]

