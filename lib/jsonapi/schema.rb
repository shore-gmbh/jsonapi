module Jsonapi
  class Schema
    class << self
      attr_reader :_type

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
    end

    def type
      self.class._type
    end

    def attributes
      self.class._attributes
    end
  end
end
