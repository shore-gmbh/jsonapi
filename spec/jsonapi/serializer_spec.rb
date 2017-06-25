require 'spec_helper'

require 'jsonapi/serializer'
require 'jsonapi/schema'

RSpec.describe Jsonapi::Serializer do
  describe '#id' do
    it 'reads the id from the data object' do
      data = { id: 1 }
      subject = build_serializer(data: data)

      id = subject.id

      expect(id).to eq(data[:id])
    end

    it 'raises Serializer::IdNotProvided if data does not contain an id' do
      data = { name: 'Thiago' }
      subject = build_serializer(data: data)

      expect { subject.id }.to raise_error(Jsonapi::Serializer::IdNotProvided)
    end
  end

  describe '#type' do
    it 'reads the type from the schema' do
      schema = double(type: :appointments)
      subject = build_serializer(schema: schema)

      type = subject.type

      expect(type).to eq(schema.type)
    end
  end

  describe '#attributes' do
    it 'returns a hash' do
      subject = build_serializer

      attributes = subject.attributes

      expect(attributes).to be_a(Hash)
    end

    it 'contains all of keys from the schema attributes' do
      schema = double(attributes: %i[name test])
      subject = build_serializer(schema: schema)

      attributes = subject.attributes

      expect(attributes.keys).to contain_exactly(:name, :test)
    end

    it 'merges the schema attributes with the data received' do
      schema = double(attributes: %i[name test])
      data = { name: 'Thiago' }
      subject = build_serializer(schema: schema, data: data)

      attributes = subject.attributes

      expect(attributes).to eq(name: 'Thiago', test: nil)
    end
  end

  describe '#relationships' do
    it 'returns a hash' do
      subject = build_serializer

      relationships = subject.relationships

      expect(relationships).to be_a(Hash)
    end

    it 'maps uses the relationship names + _id(s) from the data object' do
      schema = Class.new(Jsonapi::Schema) do
        has_one :user, type: :users
        has_many :posts, type: :posts
      end
      data = { user_id: 1, posts_ids: [3, 4] }
      subject = build_serializer(schema: schema.new, data: data)

      relationships = subject.relationships

      expect(relationships).to eq(
        user: {
          data: { type: :users, id: 1 }
        },
        posts: {
          data: [
            { type: :posts, id: 3 },
            { type: :posts, id: 4 }
          ]
        }
      )
    end
  end

  def build_serializer(override = {})
    described_class.new(default_serializer_params.merge(override))
  end

  def default_serializer_params
    {
      schema: Class.new(Jsonapi::Schema).new,
      data: {}
    }
  end
end
