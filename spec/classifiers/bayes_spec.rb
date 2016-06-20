require 'spec_helper'

describe Weka::Classifiers::Bayes do
  it_behaves_like 'class builder'

  [
    :BayesNet,
    :NaiveBayes,
    :NaiveBayesMultinomial,
    :NaiveBayesMultinomialText,
    :NaiveBayesMultinomialUpdateable,
    :NaiveBayesUpdateable
  ].each do |class_name|
    it "should define a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
