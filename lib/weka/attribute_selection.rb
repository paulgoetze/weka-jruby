require 'weka/class_builder'

module Weka
  module AttributeSelection
    include ClassBuilder

    java_import 'weka.attributeSelection.AttributeSelection'

    build_classes :CfsSubsetEval,
                  :CorrelationAttributeEval,
                  :GainRatioAttributeEval,
                  :InfoGainAttributeEval,
                  :OneRAttributeEval,
                  :ReliefFAttributeEval,
                  :SymmetricalUncertAttributeEval,
                  :WrapperSubsetEval,
                  :GreedyStepwise,
                  :Ranker,
                  :BestFirst
  end
end
