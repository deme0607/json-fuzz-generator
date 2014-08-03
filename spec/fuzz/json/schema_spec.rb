require 'spec_helper'

describe Fuzz::Json::Schema do
  it 'has a version number' do
    expect(Fuzz::Json::Schema::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
