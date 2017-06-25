module Jsonapi
  class Serializer
    class IdNotProvided < StandardError; end

    attr_reader :schema, :data

    def initialize(params)
      @data = params.fetch(:data)
      @schema = params.fetch(:schema)
    end

    def id
      raise IdNotProvided if data[:id].nil?
      data[:id]
    end

    def type
      schema.type
    end

    def attributes
      schema.attributes.each_with_object({}) do |attribute, attributes|
        attributes[attribute] = data[attribute]
      end
    end

    def relationships
      schema.relationships.each_with_object({}) do |(name, conf), relationships|
        relationships[name] = send(
          "build_#{conf[:cardinality]}_relationship",
          conf[:type],
          name,
          data
        )
      end
    end

    private

    def build_one_relationship(type, name, data)
      { data: data_for(data["#{name}_id".to_sym], type)[0] }
    end

    def build_many_relationship(type, name, data)
      { data: data_for(data["#{name}_ids".to_sym], type) }
    end

    def data_for(ids, type)
      Array(ids).map do |id|
        { type: type, id: id }
      end
    end
  end
end
