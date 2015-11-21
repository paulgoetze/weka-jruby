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
      end
    end
  end
end
