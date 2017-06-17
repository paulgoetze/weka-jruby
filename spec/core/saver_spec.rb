require 'spec_helper'

describe Weka::Core::Saver do
  let(:instances) { load_instances('weather.arff') }

  before(:all) { @tmp_dir = File.expand_path('../../tmp/', __FILE__) }
  after(:all)  { FileUtils.remove_dir(@tmp_dir, true) }

  CLASS_METHODS = %i[save_arff save_csv save_json].freeze

  CLASS_METHODS.each do |method|
    it "responds to .#{method}" do
      expect(described_class).to respond_to method
    end
  end

  %i[arff csv json].each do |type|
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

  describe '#save_c45' do
    let(:file)       { "#{@tmp_dir}/test" }
    let(:names_file) { "#{file}.names" }
    let(:data_file)  { "#{file}.data" }

    before { instances.class_attribute = :play }

    after do
      FileUtils.rm_f(names_file)
      FileUtils.rm_f(data_file)
    end

    it 'creates a *.names file and a *.data file' do
      expect(File.exist?(names_file)).to be false
      expect(File.exist?(data_file)).to  be false

      described_class.save_c45(file: names_file, instances: instances)

      expect(File.exist?(names_file)).to be true
      expect(File.exist?(data_file)).to  be true
    end
  end
end
