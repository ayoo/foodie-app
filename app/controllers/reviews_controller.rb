class ReviewsController < ArticlesController

  set_article :review, params: [:title, :content, :place, :hours, :rating, :tags]

end