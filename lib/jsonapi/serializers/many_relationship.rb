module Jsonapi
  module Serializers
    class ManyRelationship
      attr_reader :relationships

      def initialize(params)
        @relationships = params.fetch(:relationships)
      end

      def serialize(data)
        relationships.each_with_object({}) do |(name, conf), serialized|
          serialized[name] = {
            data: data_for(data["#{name}_ids".to_sym], conf[:type])
          }
        end
      end

      private

      def data_for(ids, type)
        Array(ids).map do |id|
          { type: type, id: id }
        end
      end
    end
  end
end
