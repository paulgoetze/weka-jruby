require 'spec_helper'

describe Weka::Filters::Unsupervised::Instance do

  it_behaves_like 'class builder'

  [
    :NonSparseToSparse,
    :Randomize,
    :RemoveDuplicates,
    :RemoveFolds,
    :RemoveFrequentValues,
    :RemoveMisclassified,
    :RemovePercentage,
    :RemoveRange,
    :RemoveWithValues,
    :Resample,
    :ReservoirSample,
    :SparseToNonSparse,
    :SubsetByExpression
  ].each do |class_name|
    it "should define a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
