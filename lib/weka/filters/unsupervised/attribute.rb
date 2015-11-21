require 'weka/class_builder'

module Weka
  module Filters
    module Unsupervised
      module Attribute
        include ClassBuilder

        build_classes :AbstractTimeSeries,
                      :Add,
                      :AddCluster,
                      :AddExpression,
                      :AddID,
                      :AddNoise,
                      :AddUserFields,
                      :AddUserFieldsBeanInfo,
                      :AddValues,
                      :Center,
                      :ChangeDateFormat,
                      :ClassAssigner,
                      :ClusterMembership,
                      :Copy,
                      :Discretize,
                      :FirstOrder,
                      :InterquartileRange,
                      :KernelFilter,
                      :MakeIndicator,
                      :MathExpression,
                      :MergeInfrequentNominalValues,
                      :MergeManyValues,
                      :MergeTwoValues,
                      :NominalToBinary,
                      :NominalToString,
                      :Normalize,
                      :NumericCleaner,
                      :NumericToBinary,
                      :NumericToNominal,
                      :NumericTransform,
                      :Obfuscate,
                      :PartitionedMultiFilter,
                      :PKIDiscretize,
                      :PotentialClassIgnorer,
                      :PrincipalComponents,
                      :RandomProjection,
                      :RandomSubset,
                      :Remove,
                      :RemoveByName,
                      :RemoveType,
                      :RemoveUseless,
                      :RenameAttribute,
                      :RenameNominalValues,
                      :Reorder,
                      :ReplaceMissingValues,
                      :ReplaceMissingWithUserConstant,
                      :ReplaceWithMissingValue,
                      :SortLabels,
                      :Standardize,
                      :StringToNominal,
                      :StringToWordVector,
                      :SwapValues,
                      :TimeSeriesDelta,
                      :TimeSeriesTranslate,
                      :Transpose
      end
    end
  end
end
