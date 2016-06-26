app = angular.module('foodies',
  [
    'ngRoute',
    'ngResource',
    'ngMessages',
    'ui.bootstrap',
    'templates'
  ]
)

app.config [
  '$routeProvider'
  ($routeProvider) ->
    $routeProvider
    .when '/',
      controller: "ActivitiesController"
      templateUrl: "activities/index.html"
    .when '/shared/content_not_found',
      templateUrl: "shared/content_not_found.html"

    .when '/blogs',
      controller: "BlogsController"
      templateUrl: "blogs/index.html"
    .when '/blogs/new',
      controller: "BlogsNewController"
      templateUrl: "blogs/form.html"
    .when '/blogs/:id',
      controller: "BlogsViewController"
      templateUrl: "blogs/view.html"
    .when '/blogs/:id/edit',
      controller: "BlogsEditController"
      templateUrl: "blogs/form.html",
    .when '/blogs/:id/delete',
      controller: "BlogsDeleteController"
      templateUrl: "blogs/confirm.html"

    .when '/recipes',
      controller: "RecipesController"
      templateUrl: "recipes/index.html"
    .when '/recipes/new',
      controller: "RecipesNewController"
      templateUrl: "recipes/form.html"
    .when '/recipes/:id',
      controller: "RecipesViewController"
      templateUrl: "recipes/view.html"
    .when '/recipes/:id/edit',
      controller: "RecipesEditController"
      templateUrl: "recipes/form.html",
    .when '/recipes/:id/delete',
      controller: "RecipesDeleteController"
      templateUrl: "recipes/confirm.html"

    .when '/reviews',
      controller: "ReviewsController"
      templateUrl: "reviews/index.html"
    .when '/reviews/new',
      controller: "ReviewsNewController"
      templateUrl: "reviews/form.html"
    .when '/reviews/:id',
      controller: "ReviewsViewController"
      templateUrl: "reviews/view.html"
    .when '/reviews/:id/edit',
      controller: "ReviewsEditController"
      templateUrl: "reviews/form.html",
    .when '/reviews/:id/delete',
      controller: "ReviewsDeleteController"
      templateUrl: "reviews/confirm.html"
]