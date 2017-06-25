require 'jsonapi/serializers/attributes'
require 'jsonapi/serializers/relationships'

module Jsonapi
  class IdNotProvided < StandardError; end

  class ResourceSerializer
    attr_reader :schema, :attributes_serializer, :relationships_serializer

    def initialize(params)
      @schema = params.fetch(:schema)
      @attributes_serializer = Jsonapi::Serializers::Attributes.new(
        attributes: schema.attributes
      )
      @relationships_serializer = Jsonapi::Serializers::Relationships.new(
        relationships: schema.relationships
      )
    end

    def serialize(data)
      raise IdNotProvided if data[:id].nil?

      {
        id: data[:id],
        type: schema.type,
        attributes: attributes_serializer.serialize(data),
        relationships: relationships_serializer.serialize(data)
      }
    end
  end
end
