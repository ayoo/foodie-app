class RecipesController < ArticlesController

  set_article :recipe, params: [:title, :content, :style, :yield, :ingredients, :cook_time, :ready_time]

end