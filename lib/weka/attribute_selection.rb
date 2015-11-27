require 'weka/class_builder'

module Weka
  module AttributeSelection
    include ClassBuilder

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
