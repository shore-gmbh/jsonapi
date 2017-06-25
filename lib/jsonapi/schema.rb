module Jsonapi
  class TypeMustBeDefined < StandardError; end

  class Schema
    class << self
      attr_reader :_type

      def _relationships
        @_relationships ||= {}
        @_relationships
      end

      def add_relationship(name:, type:, cardinality:)
        _relationships[name] = { type: type, cardinality: cardinality }
      end

      def _attributes
        @_attributes ||= []
        @_attributes
      end

      def type(type)
        @_type = type
      end

      def attribute(attribute)
        _attributes << attribute
      end

      # rubocop:disable Style/PredicateName
      def has_one(name, type:)
        add_relationship(name: name, type: type, cardinality: :one)
      end
      # rubocop:enable Style/PredicateName

      # rubocop:disable Style/PredicateName
      def has_many(name, type:)
        add_relationship(name: name, type: type, cardinality: :many)
      end
      # rubocop:enable Style/PredicateName
    end

    def type
      self.class._type || raise(TypeMustBeDefined)
    end

    def attributes
      self.class._attributes
    end

    def relationships
      self.class._relationships
    end
  end
end
