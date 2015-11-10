require 'spec_helper'

describe Weka::Core::Parser do

  CLASS_METHODS = %i{ parse_arff parse_csv parse_json }

  CLASS_METHODS.each do |method|
    it "responds to ::#{method}" do
      expect(Weka::Core::Parser).to respond_to method
    end
  end

  describe '#parse_arff' do
    it 'returns an Instances object for a given ARFF file' do
      file = File.expand_path('../../support/resources/weather.arff', __FILE__)
      expect(Weka::Core::Parser.parse_arff(file)).to be_kind_of Weka::Core::Instances
    end
  end

  describe '#parse_csv' do
    it 'returns an Instances object for a given CSV file' do
      file = File.expand_path('../../support/resources/weather.csv', __FILE__)
      expect(Weka::Core::Parser.parse_csv(file)).to be_kind_of Weka::Core::Instances
    end
  end
end
