require 'spec_helper'

describe Weka::Core::Loader do
  CLASS_METHODS = %i(load_arff load_csv load_json).freeze

  CLASS_METHODS.each do |method|
    it "responds to .#{method}" do
      expect(described_class).to respond_to method
    end
  end

  [:arff, :csv, :json].each do |type|
    method = "load_#{type}"

    describe "##{method}" do
      let(:file) do
        File.expand_path("../../support/resources/weather.#{type}", __FILE__)
      end

      it "returns an Instances object for a given #{type.upcase} file" do
        instances = described_class.send(method, file)
        expect(instances).to be_kind_of Weka::Core::Instances
      end
    end
  end
end
