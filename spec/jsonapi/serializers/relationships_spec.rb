require 'spec_helper'

require 'jsonapi/serializers/relationships'

RSpec.describe Jsonapi::Serializers::Relationships do
  describe '#serialize' do
    it 'serializes has_one relationships using {name}_id from data' do
      relationships = {
        user: { type: :users, cardinality: :one },
        account: { type: :accounts, cardinality: :one }
      }
      data = { user_id: 1, account_id: 2 }
      subject = build_serializer(relationships: relationships)

      serialized = subject.serialize(data)

      expect(serialized).to eq(
        user: {
          data: { type: :users, id: 1 }
        },
        account: {
          data: { type: :accounts, id: 2 }
        }
      )
    end

    it 'serializes has_many relationships using {name}_ids from data' do
      relationships = {
        users: { type: :users, cardinality: :many },
        posts: { type: :posts, cardinality: :many }
      }
      data = { users_ids: [1, 2], posts_ids: [2, 3, 4] }
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
            { type: :posts, id: 2 },
            { type: :posts, id: 3 },
            { type: :posts, id: 4 }
          ]
        }
      )
    end
  end

  def build_serializer(relationships:)
    described_class.new(relationships: relationships)
  end
end
