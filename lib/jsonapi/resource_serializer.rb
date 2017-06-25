require 'jsonapi/serializers/attributes'

module Jsonapi
  class IdNotProvided < StandardError; end

  class ResourceSerializer
    attr_reader :schema, :attributes_serializer

    def initialize(params)
      @schema = params.fetch(:schema)
      @attributes_serializer = Jsonapi::Serializers::Attributes.new(
        attributes: schema.attributes
      )
    end

    def serialize(data)
      raise IdNotProvided if data[:id].nil?

      {
        id: data[:id],
        type: schema.type,
        attributes: attributes_serializer.serialize(data)
      }
    end
  end
end
