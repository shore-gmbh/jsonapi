require 'spec_helper'

require 'jsonapi/schema'

RSpec.describe Jsonapi::Schema do
  describe '.type' do
    it 'sets the type of every entity of this schema' do
      class TestSchema < described_class
        type :todos
      end

      expect(TestSchema.new.type).to eq(:todos)
    end

    it 'works correctly with multiple inherited classes' do
      class TestSchema1 < described_class
        type :todos
      end

      class TestSchema2 < described_class
        type :users
      end

      expect(TestSchema1.new.type).to eq(:todos)
      expect(TestSchema2.new.type).to eq(:users)
    end
  end

  describe '.attribute' do
    it 'adds each attribute to the attributes array' do
      class TestSchema < described_class
        type :users

        attribute :name
        attribute :email
      end

      expect(TestSchema.new.attributes).to contain_exactly(:name, :email)
    end

    it 'works correctly with multiple inherited classes' do
      class TestSchema1 < described_class
        type :todos

        attribute :task
      end

      class TestSchema2 < described_class
        type :users

        attribute :name
        attribute :email
      end

      expect(TestSchema1.new.attributes).to contain_exactly(:task)
      expect(TestSchema2.new.attributes).to contain_exactly(:name, :email)
    end
  end
end
