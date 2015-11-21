require 'spec_helper'

describe Weka::Classifiers::Meta do

  [
    :AdaBoostM1,
    :AdditiveRegression,
    :AttributeSelectedClassifier,
    :Bagging,
    :ClassificationViaRegression,
    :CostSensitiveClassifier,
    :CVParameterSelection,
    :FilteredClassifier,
    :IterativeClassifierOptimizer,
    :LogitBoost,
    :MultiClassClassifier,
    :MultiClassClassifierUpdateable,
    :MultiScheme,
    :RandomCommittee,
    :RandomizableFilteredClassifier,
    :RandomSubSpace,
    :RegressionByDiscretization,
    :Stacking,
    :Vote
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
