require_relative "base"

module Administrate
  module Field
    class Polymorphic < Base
      def displayed_associated_resource
        associated_dashboard.display_resource(data)
      end

      private

      # TODO abstract to Relationship superclass
      def associated_dashboard
        Object.const_get("#{associated_class_name}Dashboard").new
      end
    end
  end
end
