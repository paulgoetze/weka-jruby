require 'spec_helper'
require 'fileutils'

describe Weka::Core::Instances do
  it { is_expected.to respond_to :each }
  it { is_expected.to respond_to :each_with_index }
  it { is_expected.to respond_to :each_attribute }
  it { is_expected.to respond_to :each_attribute_with_index }

  it { is_expected.to respond_to :to_arff }
  it { is_expected.to respond_to :to_csv }
  it { is_expected.to respond_to :to_json }

  describe 'converter' do
    let(:file) { File.expand_path('../../support/resources/weather.arff', __FILE__) }
    let(:instances) { Weka::Core::Parser.parse_arff(file) }

    before(:all) { @tmp_dir = File.expand_path('../../tmp/', __FILE__) }

    after :all do
      FileUtils.remove_dir(@tmp_dir, true)
    end

    [:arff, :csv, :json].each do |type|
      describe "#to_#{type}" do
        it "should save a test.#{type} file" do
          test_file = "#{@tmp_dir}/test.#{type}"
          expect(File.exists?(test_file)).to be false
          instances.to_arff(test_file)
          expect(File.exists?(test_file)).to be true
        end
      end
    end

  end
end
