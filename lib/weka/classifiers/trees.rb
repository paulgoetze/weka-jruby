require 'weka/class_builder'

module Weka
  module Classifiers
    module Trees
      include ClassBuilder

      build_classes :DecisionStump,
                    :HoeffdingTree,
                    :J48,
                    :LMT,
                    :M5P,
                    :RandomForest,
                    :RandomTree,
                    :REPTree
    end
  end
end
