require 'spec_helper'
require 'jsonapi'

RSpec.describe Jsonapi do
  it 'has a version number' do
    expect(Jsonapi::VERSION).not_to be nil
  end
end
