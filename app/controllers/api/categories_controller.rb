module Api
    class CategoriesController < ApplicationController
      def index
        categories = Category.all

        render json: categories.map { |category|
          {
            id: category.id,
            name: category.name,
            description: category.description
          }
        }
      end
    end
end
