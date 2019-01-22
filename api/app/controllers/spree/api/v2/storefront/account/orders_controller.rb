module Spree
  module Api
    module V2
      module Storefront
        module Account
          class OrdersController < ::Spree::Api::V2::BaseController
            include Spree::Api::V2::CollectionOptionsHelpers
            before_action :require_spree_current_user

            def index
              render_serialized_payload { serialize_collection(paginated_collection) }
            end

            def show
              spree_authorize! :show, resource

              render_serialized_payload { serialize_resource(resource) }
            end

            private

            def paginated_collection
              collection_paginator.constantize.new(sorted_collection, params).call
            end

            def sorted_collection
              collection_sorter.constantize.new(collection, params).call
            end

            def collection
              collection_finder.constantize.new(user: spree_current_user).execute
            end

            def resource
              resource = resource_finder.constantize.new(user: spree_current_user, number: params[:id]).execute.take
              raise ActiveRecord::RecordNotFound if resource.nil?

              resource
            end

            def serialize_collection(collection)
              collection_serializer.constantize.new(
                collection,
                collection_options(collection)
              ).serializable_hash
            end

            def serialize_resource(resource)
              resource_serializer.constantize.new(
                resource,
                include: resource_includes,
                sparse_fields: sparse_fields
              ).serializable_hash
            end

            def collection_serializer
              Spree::Api::Dependencies.storefront_cart_serializer
            end

            def resource_serializer
              Spree::Api::Dependencies.storefront_cart_serializer
            end

            def collection_finder
              Spree::Api::Dependencies.storefront_completed_order_finder
            end

            def resource_finder
              Spree::Api::Dependencies.storefront_completed_order_finder
            end

            def collection_sorter
              Spree::Api::Dependencies.storefront_order_sorter
            end

            def collection_paginator
              Spree::Api::Dependencies.storefront_collection_paginator
            end

            def collection_options(collection)
              {
                links: collection_links(collection),
                meta: collection_meta(collection),
                include: resource_includes,
                sparse_fields: sparse_fields
              }
            end
          end
        end
      end
    end
  end
end
