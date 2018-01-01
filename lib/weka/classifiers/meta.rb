require 'weka/class_builder'

module Weka
  module Classifiers
    module Meta
      include ClassBuilder

      build_classes :AdaBoostM1,
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
                    :Vote,
                    :WeightedInstancesHandlerWrapper
    end
  end
end
