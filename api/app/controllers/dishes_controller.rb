class DishesController < ApplicationController
  def index
    render json: {
      dishes: search,
      totalPage: Dish.all.page.total_pages
    }
  end

  def create
    dish = Dish.create permitted_params
    if dish.persisted?
      render json: dish
    else
      render json: { error: dish.errors.full_messages.to_sentence }, status: 422
    end
  end

  def update
    dish = Dish.find_by(id: params[:id])
    if dish.present? && dish.update(permitted_params)
      render json: dish
    else
      render json: { error: dish.errors.full_messages.to_sentence }, status: 422
    end
  end

  def destroy
    dish = Dish.find_by(id: params[:id])
    if dish.present? && dish.destroy
      render json: dish
    else
      render json: { error: dish.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

  def collection
    Dish.all
  end

  def search
    scope = collection
    scope = scope.where("lower(name) like ?", "%#{params[:name].downcase}%") if params[:name].present?
    scope = scope.order(:name).page(params[:page] || 1)
    scope
  end

  def permitted_params
    params.permit(:id, :name, :description)
  end
end
