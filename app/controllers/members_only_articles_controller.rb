class MembersOnlyArticlesController < ApplicationController
  before_action :authorize_user, only: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  private

  def authorize_user
    if current_user.nil?
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
end
