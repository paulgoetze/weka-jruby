require 'weka/class_builder'

module Weka
  module Filters
    module Unsupervised
      module Instance
        include ClassBuilder

        build_classes :NonSparseToSparse,
                      :Randomize,
                      :RemoveDuplicates,
                      :RemoveFolds,
                      :RemoveFrequentValues,
                      :RemoveMisclassified,
                      :RemovePercentage,
                      :RemoveRange,
                      :RemoveWithValues,
                      :Resample,
                      :ReservoirSample,
                      :SparseToNonSparse,
                      :SubsetByExpression
      end
    end
  end
end
