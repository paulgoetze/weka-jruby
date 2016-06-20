require 'spec_helper'

describe Weka::Core::Converters do
  it_behaves_like 'class builder'

  [
    :ArffLoader,
    :ArffSaver,
    :CSVLoader,
    :CSVSaver,
    :JSONLoader,
    :JSONSaver
  ].each do |class_name|
    it "should define a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end
  end
end
