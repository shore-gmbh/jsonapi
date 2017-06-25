require 'spec_helper'

require 'jsonapi/serializers/one_relationship'

RSpec.describe Jsonapi::Serializers::OneRelationship do
  describe '#serialize' do
    it 'returns a hash if there is no relationships' do
      relationships = {}
      data = {}
      subject = build_serializer(relationships: relationships)

      serialized = subject.serialize(data)

      expect(serialized).to eq({})
    end

    it 'maps uses the relationship names + _id from the data object' do
      relationships = {
        user: { type: :users },
        account: { type: :accounts }
      }
      data = { user_id: 1, account_id: 3 }
      subject = build_serializer(relationships: relationships)

      serialized = subject.serialize(data)

      expect(serialized).to eq(
        user: { data: { type: :users, id: 1 } },
        account: { data: { type: :accounts, id: 3 } }
      )
    end
  end

  def build_serializer(override)
    described_class.new(override)
  end
end
