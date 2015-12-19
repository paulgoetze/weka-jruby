require 'spec_helper'

describe Weka::AttributeSelection do

  it_behaves_like 'class builder'

  [
    :CfsSubsetEval,
    :CorrelationAttributeEval,
    :GainRatioAttributeEval,
    :InfoGainAttributeEval,
    :OneRAttributeEval,
    :ReliefFAttributeEval,
    :SymmetricalUncertAttributeEval,
    :WrapperSubsetEval,
    :GreedyStepwise,
    :Ranker,
    :BestFirst,
    :AttributeSelection
  ].each do |class_name|
    it "should define a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
