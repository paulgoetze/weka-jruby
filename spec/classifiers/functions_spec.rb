require 'spec_helper'

describe Weka::Classifiers::Functions do
  it_behaves_like 'class builder'

  [
    :GaussianProcesses,
    :LinearRegression,
    :Logistic,
    :MultilayerPerceptron,
    :SGD,
    :SGDText,
    :SimpleLinearRegression,
    :SimpleLogistic,
    :SMO,
    :SMOreg,
    :VotedPerceptron
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
