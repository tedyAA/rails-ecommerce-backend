module Api
    class TypesController < ApplicationController
      def index
        types = Type.all

        render json: types.map { |type|
          {
            id: type.id,
            name: type.name,
            description: type.description
          }
        }
      end
    end
end
