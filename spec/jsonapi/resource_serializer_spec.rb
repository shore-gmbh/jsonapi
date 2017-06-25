require 'spec_helper'

require 'jsonapi/serializer'
require 'jsonapi/schema'

RSpec.describe Jsonapi::ResourceSerializer do
  describe '#serialize' do
    it 'correctly serializes the id' do
      data = valid_data(id: 1)
      subject = build_serializer

      serialized = subject.serialize(data)

      expect(serialized).to match(a_hash_including(id: data[:id]))
    end

    it 'raises an error if there is no id present on the data' do
      data = valid_data
      data.delete(:id)
      subject = build_serializer

      serialize_action = -> { subject.serialize(data) }

      expect(serialize_action).to raise_error(Jsonapi::IdNotProvided)
    end

    it 'uses the type from the schema' do
      schema = build_schema
      subject = build_serializer(schema: schema)

      serialized = subject.serialize(valid_data)

      expect(serialized).to match(a_hash_including(type: schema.type))
    end

    it 'serializes the attributes' do
      schema = build_schema(attributes: %i[name email])
      data = valid_data(name: 'Thiago')
      subject = build_serializer(schema: schema)

      serialized = subject.serialize(data)

      expect(serialized).to match(
        a_hash_including(
          attributes: {
            name: data[:name],
            email: data[:email]
          }
        )
      )
    end
  end

  def build_serializer(override = {})
    described_class.new(default_serializer_params.merge(override))
  end

  def valid_data(override = {})
    { id: 1 }.merge(override)
  end

  def build_schema(attributes: [], type: :posts)
    Class.new(Jsonapi::Schema) do
      type type

      attributes.each { |attr| attribute attr }
    end.new
  end

  def default_serializer_params
    {
      schema: build_schema
    }
  end
end
