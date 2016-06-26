class BlogsController < ArticlesController

  set_article :blog, params: [:title, :content, :tags]

end