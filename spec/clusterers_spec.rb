require 'spec_helper'

describe Weka::Clusterers do
  it_behaves_like 'class builder'

  %i[
    Cobweb
    Canopy
    EM
    FarthestFirst
    FilteredClusterer
    HierarchicalClusterer
    MakeDensityBasedClusterer
    SimpleKMeans
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
