require 'spec_helper'

describe Weka::Filters do
  it_behaves_like 'class builder'

  %i[
    Filter
    CheckSource
    Filter
    MultiFilter
    RenameRelation
    SimpleBatchFilter
    SimpleFilter
    SimpleStreamFilter
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
