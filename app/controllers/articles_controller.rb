class ArticlesController < ApplicationController

  def index
    articles = my_article.all
    render json: articles
  end

  def show
    article = article_class.find_by(id: params[:id])
    if article
      render json: article
    else
      render status: 404, json: {error: "Article not found"}
    end
  end

  def create
    article = my_article.build(article_params)
    if article.save
      render status: 201, json: { message: "Article was created successfully" }
    else
      render status: 422,  json: {error: article.errors.full_messages}
    end
  end

  def update
    article = my_article.find_by(id: params[:id])
    if article.update_attributes(article_params)
      render status: 200, json: { message: "Article was updated successfully" }
    else
      render status: 422,  json: {error: article.errors.full_messages}
    end
  end

  def destroy
    article = my_article.find_by(id: params[:id])
    if article.update_attribute(:deleted_at, Time.zone.now)
      render status: 200, json: { message: "Article was deleted successfully" }
    else
      render status: 422,  json: {error: article.errors.full_messages}
    end
  end

  protected
    def self.set_article(class_sym, param_array=[])
      define_method(:article_class) do
        class_sym.to_s.capitalize.constantize
      end
      define_method(:my_article) do
        current_user.send(class_sym.to_s.pluralize)
      end
      define_method(:article_params) do
        params.require(class_sym).permit(*param_array)
      end
    end

end