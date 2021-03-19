module Spree
  module Api
    module V2
      module Platform
        class ResourceController < ::Spree::Api::V2::ResourceController
          before_action -> { doorkeeper_authorize! :admin, :read }, only: [:index, :show]
          before_action only: [:create, :update, :destroy] do
            doorkeeper_authorize! :admin, :write
          end

          protected

          def resource_serializer
            "Spree::Api::V2::Platform::#{model_class.to_s.demodulize}Serializer".constantize
          end

          def collection_serializer
            resource_serializer
          end

          def collection
            @collection ||= scope.ransack(params[:filter]).result
          end

          def spree_current_user
            return nil unless doorkeeper_token
            return @spree_current_user if @spree_current_user

            @spree_current_user ||= Spree.user_class.find_by(id: doorkeeper_token.resource_owner_id)
          end
        end
      end
    end
  end
end
