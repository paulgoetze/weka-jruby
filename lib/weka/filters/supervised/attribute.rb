require 'weka/class_builder'

module Weka
  module Filters
    module Supervised
      module Attribute
        include ClassBuilder

        build_classes :AddClassification,
                      :AttributeSelection,
                      :ClassConditionalProbabilities,
                      :ClassOrder,
                      :Discretize,
                      :MergeNominalValues,
                      :NominalToBinary,
                      :PartitionMembership

        class AttributeSelection
          alias :use_evaluator :set_evaluator
          alias :use_search    :set_search
        end

      end
    end
  end
end
