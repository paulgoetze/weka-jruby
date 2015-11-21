require 'weka/class_builder'

module Weka
  module Classifiers
    module Bayes
      include ClassBuilder

      build_classes :BayesNet,
                    :NaiveBayes,
                    :NaiveBayesMultinomial,
                    :NaiveBayesMultinomialText,
                    :NaiveBayesMultinomialUpdateable,
                    :NaiveBayesUpdateable
    end
  end
end
