require 'spec_helper'

require 'jsonapi/resource_serializer'
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

    it 'serializes relationships' do
      schema = build_schema(
        relationships: {
          user: { type: :users, cardinality: :has_one },
          posts: { type: :posts, cardinality: :has_many }
        }
      )
      data = valid_data(user_id: 1, posts_ids: [1, 2])
      subject = build_serializer(schema: schema)

      serialized = subject.serialize(data)

      expect(serialized).to match(
        a_hash_including(
          relationships: {
            user: { data: { type: :users, id: 1 } },
            posts: {
              data: [
                { type: :posts, id: 1 },
                { type: :posts, id: 2 }
              ]
            }
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

  def build_schema(attributes: [], type: :posts, relationships: {})
    Class.new(Jsonapi::Schema) do
      type type

      attributes.each { |attr| attribute attr }

      relationships.each do |(name, conf)|
        send(conf[:cardinality], name, type: conf[:type])
      end
    end.new
  end

  def default_serializer_params
    {
      schema: build_schema
    }
  end
end
