require 'spec_helper'

describe Weka::Core::Parser do

  CLASS_METHODS = %i{ parse_arff parse_csv parse_json }

  CLASS_METHODS.each do |method|
    it "responds to ::#{method}" do
      expect(Weka::Core::Parser).to respond_to method
    end
  end

  [:arff, :csv, :json].each do |type|
    describe "#parse_#{type}" do
      let(:file) { File.expand_path("../../support/resources/weather.#{type}", __FILE__) }

      it "returns an Instances object for a given #{type.upcase} file" do
        instances = Weka::Core::Parser.send("parse_#{type}", file)
        expect(instances).to be_kind_of Weka::Core::Instances
      end
    end
  end

end
