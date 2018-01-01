require 'spec_helper'

describe Weka::Filters::Unsupervised::Attribute do
  it_behaves_like 'class builder'

  %i[
    AbstractTimeSeries
    Add
    AddCluster
    AddExpression
    AddID
    AddNoise
    AddUserFields
    AddUserFieldsBeanInfo
    AddValues
    CartesianProduct
    Center
    ChangeDateFormat
    ClassAssigner
    ClusterMembership
    Copy
    DateToNumeric
    Discretize
    FirstOrder
    FixedDictionaryStringToWordVector
    InterquartileRange
    KernelFilter
    MakeIndicator
    MathExpression
    MergeInfrequentNominalValues
    MergeManyValues
    MergeTwoValues
    NominalToBinary
    NominalToString
    Normalize
    NumericCleaner
    NumericToBinary
    NumericToDate
    NumericToNominal
    NumericTransform
    Obfuscate
    OrdinalToNumeric
    PartitionedMultiFilter
    PKIDiscretize
    PotentialClassIgnorer
    PrincipalComponents
    RandomProjection
    RandomSubset
    Remove
    RemoveByName
    RemoveType
    RemoveUseless
    RenameAttribute
    RenameNominalValues
    Reorder
    ReplaceMissingValues
    ReplaceMissingWithUserConstant
    ReplaceWithMissingValue
    SortLabels
    Standardize
    StringToNominal
    StringToWordVector
    SwapValues
    TimeSeriesDelta
    TimeSeriesTranslate
    Transpose
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
