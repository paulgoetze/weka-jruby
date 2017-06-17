require 'spec_helper'

describe Weka::Filters::Supervised::Instance do
  it_behaves_like 'class builder'

  %i[
    ClassBalancer
    Resample
    SpreadSubsample
    StratifiedRemoveFolds
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
