require 'weka/class_builder'

module Weka
  module AttributeSelection
    module Search
      include ClassBuilder

      build_classes :GreedyStepwise,
                    :Ranker,
                    :BestFirst,
                    weka_module: 'weka.attributeSelection'
    end
  end
end
