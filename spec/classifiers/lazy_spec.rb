require 'spec_helper'

describe Weka::Classifiers::Lazy do
  it_behaves_like 'class builder'

  %i[
    IBk
    KStar
    LWL
  ].each do |class_name|
    it "definess a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
