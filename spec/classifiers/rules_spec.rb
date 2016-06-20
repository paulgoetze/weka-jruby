require 'spec_helper'

describe Weka::Classifiers::Rules do
  it_behaves_like 'class builder'

  [
    :DecisionTable,
    :JRip,
    :M5Rules,
    :OneR,
    :PART,
    :ZeroR
  ].each do |class_name|
    it "should define a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
