require 'spec_helper'

require 'jsonapi/serializers/attributes'

RSpec.describe Jsonapi::Serializers::Attributes do
  describe '#serialize' do
    it 'always returns a hash' do
      attributes = []
      data = {}
      subject = build_serializer(attributes: attributes)

      serialized = subject.serialize(data)

      expect(serialized).to be_a(Hash)
    end

    it 'always contains all of keys from the schema attributes' do
      attributes = %i[name email]
      data = {}
      subject = build_serializer(attributes: attributes)

      serialized = subject.serialize(data)

      expect(serialized.keys).to contain_exactly(:name, :email)
    end

    it 'merges the schema attributes with the data received' do
      attributes = %i[name empty]
      data = { name: 'Thiago' }
      subject = build_serializer(attributes: attributes)

      serialized = subject.serialize(data)

      expect(serialized).to eq(name: 'Thiago', empty: nil)
    end
  end

  def build_serializer(override)
    described_class.new(override)
  end
end
