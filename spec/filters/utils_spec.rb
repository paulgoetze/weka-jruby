require 'spec_helper'

describe Weka::Filters::Utils do

  subject do
    Class.new { include Weka::Filters::Utils }.new
  end

  it { is_expected.to respond_to :filter }

  describe '#filter' do
    let(:instances) { double('Weka::Core::Instances') }

    before do
      allow(subject).to receive(:set_input_format).and_return(nil)
      allow(Weka::Filters::Filter).to receive(:use_filter).and_return(nil)
    end

    it 'should set the filter input format' do
      expect(subject).to receive(:set_input_format).with(instances)
      subject.filter(instances)
    end

    it 'should apply the including filter' do
      expect(Weka::Filters::Filter)
        .to receive(:use_filter)
        .with(instances, subject)

      subject.filter(instances)
    end
  end
end
