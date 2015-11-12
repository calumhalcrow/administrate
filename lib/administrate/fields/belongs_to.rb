require_relative "base"

module Administrate
  module Field
    class BelongsTo < Field::Base
      def self.permitted_attribute(attr)
        :"#{attr}_id"
      end

      def permitted_attribute
        self.class.permitted_attribute(attribute)
      end

      def associated_resource_options
        candidate_resources.map do |resource|
          [display_candidate_resource(resource), resource.id]
        end
      end

      def displayed_associated_resource
        associated_dashboard.display_resource(data)
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
        options.fetch(:class_name, attribute.to_s.camelcase)
      end
    end
  end
end
