require 'spec_helper'

describe Weka::Classifiers::Lazy do

  [
    :IBk,
    :KStar,
    :LWL
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
