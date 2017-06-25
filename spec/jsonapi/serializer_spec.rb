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
