require 'spec_helper'

describe Weka::Core::Loader do
  %i[load_arff load_csv load_json load_c45].each do |method|
    it "responds to .#{method}" do
      expect(described_class).to respond_to method
    end
  end

  %i[arff csv json].each do |type|
    method = "load_#{type}"

    describe "##{method}" do
      let(:file) { resources_file("weather.#{type}") }

      it "returns an Instances object for a given #{type.upcase} file" do
        instances = described_class.send(method, file)
        expect(instances).to be_a Weka::Core::Instances
      end
    end
  end

  describe '#load_c45' do
    let(:names_file) { resources_file('weather.names') }
    let(:data_file)  { resources_file('weather.data') }

    it 'returns an Instances object for a given *.names file' do
      instances = described_class.load_c45(names_file)
      expect(instances).to be_a Weka::Core::Instances
    end

    it 'returns an Instances object for a given *.data file' do
      instances = described_class.load_c45(data_file)
      expect(instances).to be_a Weka::Core::Instances
    end
  end
end
