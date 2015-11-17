require 'spec_helper'

describe Weka::Core::Attribute do

  let(:values) { ['yes', 'no'] }
  subject { Weka::Core::Attribute.new('class', values) }

  it { is_expected.to respond_to :values }

  describe '#values' do
    it 'should return an array of the values' do
      expect(subject.values).to eq values
    end
  end
end