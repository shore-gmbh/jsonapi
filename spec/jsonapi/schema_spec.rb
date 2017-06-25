require 'spec_helper'

require 'jsonapi/schema'

RSpec.describe Jsonapi::Schema do
  describe '#type' do
    it 'raises if no type is defined' do
      test_class = Class.new(described_class)

      type_call = -> { test_class.new.type }

      expect(type_call).to raise_error(Jsonapi::TypeMustBeDefined)
    end

    it 'sets the type of every entity of this schema' do
      test_class = Class.new(described_class) do
        type :todos
      end

      expect(test_class.new.type).to eq(:todos)
    end

    it 'works correctly with multiple inherited classes' do
      test_class1 = Class.new(described_class) do
        type :todos
      end

      test_class2 = Class.new(described_class) do
        type :users
      end

      expect(test_class1.new.type).to eq(:todos)
      expect(test_class2.new.type).to eq(:users)
    end
  end

  describe '#attribute' do
    it 'returns an empty array if no attributes were set' do
      test_class = Class.new(described_class)

      expect(test_class.new.attributes).to eq([])
    end

    it 'adds each attribute to the attributes array' do
      test_class = Class.new(described_class) do
        attribute :name
        attribute :email
      end

      expect(test_class.new.attributes).to contain_exactly(:name, :email)
    end

    it 'works correctly with multiple inherited classes' do
      test_class1 = Class.new(described_class) do
        attribute :task
      end

      test_class2 = Class.new(described_class) do
        attribute :name
        attribute :email
      end

      expect(test_class1.new.attributes).to contain_exactly(:task)
      expect(test_class2.new.attributes).to contain_exactly(:name, :email)
    end
  end

  describe '#relationships' do
    it 'returns an empty hash if not declared' do
      test_class = Class.new(described_class)

      expect(test_class.new.relationships).to eq({})
    end

    it 'returns the type, cardinality indexed by name of each relationship' do
      test_class = Class.new(described_class) do
        has_one :user, type: :users
        has_many :posts, type: :blog_posts
      end

      relationships = test_class.new.relationships

      expect(relationships).to match(
        user: a_hash_including(type: :users, cardinality: :one),
        posts: a_hash_including(type: :blog_posts, cardinality: :many)
      )
    end
  end
end
