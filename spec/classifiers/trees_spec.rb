require 'spec_helper'

describe Weka::Classifiers::Trees do
  it_behaves_like 'class builder'

  [
    :DecisionStump,
    :HoeffdingTree,
    :J48,
    :LMT,
    :M5P,
    :RandomForest,
    :RandomTree,
    :REPTree
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
