require 'weka/class_builder'

module Weka
  module Classifiers
    module Rules
      include ClassBuilder

      build_classes :DecisionTable,
                    :JRip,
                    :M5Rules,
                    :OneR,
                    :PART,
                    :ZeroR
    end
  end
end
