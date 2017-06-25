module Jsonapi
  module Serializers
    class Attributes
      attr_reader :attributes

      def initialize(params)
        @attributes = params.fetch(:attributes)
      end

      def serialize(data)
        attributes.each_with_object({}) do |attribute, attributes|
          attributes[attribute] = data[attribute]
        end
      end
    end
  end
end
