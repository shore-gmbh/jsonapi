module Jsonapi
  module Serializers
    class OneRelationship
      attr_reader :relationships

      def initialize(params)
        @relationships = params.fetch(:relationships)
      end

      def serialize(data)
        relationships.each_with_object({}) do |(name, conf), serialized|
          serialized[name] = {
            data: {
              type: conf[:type],
              id: data["#{name}_id".to_sym]
            }
          }
        end
      end
    end
  end
end
