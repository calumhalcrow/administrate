require_relative "base"
require "administrate/page/collection"

module Administrate
  module Field
    class HasMany < Field::Base
      DEFAULT_LIMIT = 5

      def self.permitted_attribute(attribute)
        { "#{attribute.to_s.singularize}_ids".to_sym => [] }
      end

      def associated_collection
        Administrate::Page::Collection.new(associated_dashboard)
      end

      def attribute_key
        permitted_attribute.keys.first
      end

      def associated_resource_options
        candidate_resources.map do |resource|
          [display_candidate_resource(resource), resource.id]
        end
      end

      def limit
        options.fetch(:limit, DEFAULT_LIMIT)
      end

      def permitted_attribute
        self.class.permitted_attribute(attribute)
      end

      def resources
        data.limit(limit)
      end

      def more_than_limit?
        data.count > limit
      end

      private

      def candidate_resources
        Object.const_get(associated_class_name).all
      end

      def display_candidate_resource(resource)
        associated_dashboard.display_resource(resource)
      end

      def associated_dashboard
        Object.const_get("#{associated_class_name}Dashboard").new
      end

      def associated_class_name
        options.fetch(:class_name, attribute.to_s.singularize.camelcase)
      end
    end
  end
end
