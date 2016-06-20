require 'spec_helper'

describe Weka::Core::Saver do
  let(:instances) { load_instances('weather.arff') }

  before(:all) { @tmp_dir = File.expand_path('../../tmp/', __FILE__) }
  after(:all)  { FileUtils.remove_dir(@tmp_dir, true) }

  CLASS_METHODS = %i(save_arff save_csv save_json).freeze

  CLASS_METHODS.each do |method|
    it "responds to .#{method}" do
      expect(described_class).to respond_to method
    end
  end

  [:arff, :csv, :json].each do |type|
    method = "save_#{type}"

    describe "##{method}" do
      let(:file) { "#{@tmp_dir}/test.#{type}" }

      it "saves the given Instances to a #{type.upcase} file" do
        expect(File.exist?(file)).to be false
        described_class.send(method, file: file, instances: instances)
        expect(File.exist?(file)).to be true
      end
    end
  end
end
