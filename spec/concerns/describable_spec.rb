require 'spec_helper'

describe Weka::Concerns::Describable do

  subject do
    Class.new { include Weka::Concerns::Describable }
  end

  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :options }

  describe '.description' do
    before do
      allow_any_instance_of(subject).to receive(:global_info).and_return('')
    end

    it 'should call Weka’s #global_info on a new instance' do
      expect_any_instance_of(subject).to receive(:global_info).once
      subject.description
    end
  end

  describe '.options' do
    before do
      allow_any_instance_of(subject).to receive(:list_options).and_return([])
    end

    it 'should call Weka’s #list_options on a new instance' do
      expect_any_instance_of(subject).to receive(:list_options).once
      subject.options
    end

    it 'should return a string' do
      expect(subject.options).to be_kind_of String
    end
  end
end
