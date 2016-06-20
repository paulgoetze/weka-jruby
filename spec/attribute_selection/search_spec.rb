require 'spec_helper'

describe Weka::AttributeSelection::Search do
  subject { described_class }

  it_behaves_like 'class builder'

  [
    :GreedyStepwise,
    :Ranker,
    :BestFirst
  ].each do |class_name|
    it "should define a class #{class_name}" do
      expect(subject.const_defined?(class_name)).to be true
    end
  end
end
