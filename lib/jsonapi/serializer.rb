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
  end
end
