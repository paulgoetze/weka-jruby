require 'spec_helper'

describe Weka::AttributeSelection do

  it "should define a class AttributeSelection" do
    expect(described_class.const_defined?(:AttributeSelection)).to be true
  end
end
