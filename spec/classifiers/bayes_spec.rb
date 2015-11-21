require 'spec_helper'

describe Weka::Classifiers::Bayes do

  [
    :BayesNet,
    :NaiveBayes,
    :NaiveBayesMultinomial,
    :NaiveBayesMultinomialText,
    :NaiveBayesMultinomialUpdateable,
    :NaiveBayesUpdateable
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
