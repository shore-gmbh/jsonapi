require 'spec_helper'

require 'jsonapi/serializers/many_relationship'

RSpec.describe Jsonapi::Serializers::ManyRelationship do
  describe '#serialize' do
    it 'returns a hash if there is no relationships' do
      relationships = {}
      data = {}
      subject = build_serializer(relationships: relationships)

      serialized = subject.serialize(data)

      expect(serialized).to eq({})
    end

    it 'maps uses the relationship names + _ids from the data object' do
      relationships = {
        users: { type: :users },
        posts: { type: :posts }
      }
      data = { users_ids: [1, 2], posts_ids: [3, 4, 5] }
      subject = build_serializer(relationships: relationships)

      serialized = subject.serialize(data)

      expect(serialized).to eq(
        users: {
          data: [
            { type: :users, id: 1 },
            { type: :users, id: 2 }
          ]
        },
        posts: {
          data: [
            { type: :posts, id: 3 },
            { type: :posts, id: 4 },
            { type: :posts, id: 5 }
          ]
        }
      )
    end
  end

  def build_serializer(override)
    described_class.new(override)
  end
end
