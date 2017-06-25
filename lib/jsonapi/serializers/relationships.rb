module Jsonapi
  module Serializers
    class Relationships
      attr_reader :relationships

      def initialize(params)
        @relationships = prepare(params.fetch(:relationships))
      end

      def serialize(data)
        relationships.each_with_object({}) do |(name, conf), serialized|
          serialized[name] = {
            data: send(conf[:method], name, conf[:type], data)
          }
        end
      end

      private

      def build_one(name, type, data)
        { type: type, id: data["#{name}_id".to_sym] }
      end

      def build_many(name, type, data)
        Array(data["#{name}_ids".to_sym]).map do |id|
          { type: type, id: id }
        end
      end

      def prepare(relationships)
        relationships.each_with_object({}) do |(name, conf), prepared|
          prepared[name] = {
            method: conf[:cardinality] == :one ? :build_one : :build_many,
            type: conf[:type]
          }
        end
      end
    end
  end
end
