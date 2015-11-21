require 'weka/class_builder'

module Weka
  module Classifiers
    module Rules
      include ClassBuilder

      build_classes :DecisionTable,
                    :DecisionTableHashKey,
                    :JRip,
                    :M5Rules,
                    :OneR,
                    :PART,
                    :Rule,
                    :RuleStats,
                    :ZeroR
    end
  end
end
