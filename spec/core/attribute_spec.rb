require 'spec_helper'

describe Weka::Core::Attribute do

  let(:values) { ['yes', 'no'] }
  subject { Weka::Core::Attribute.new('class', values) }

  it { is_expected.to respond_to :values }
  it { is_expected.to respond_to :internal_value_of }

  describe '#values' do
    it 'should return an array of the values' do
      expect(subject.values).to eq values
    end
  end

  describe '#internal_value_of' do
    it 'should return the value for a numeric attribute' do
      attribute = Weka::Core::Attribute.new('attribute name')
      expect(attribute.internal_value_of(3.5)).to eq 3.5
    end

    it 'should return the internal index for a nominal attribute' do
      attribute = Weka::Core::Attribute.new('class', ['yes', 'no'])
      expect(attribute.internal_value_of('yes')).to eq 0
      expect(attribute.internal_value_of('no')).to  eq 1
    end

    it 'should return the date number value for a data attribute' do
      attribute = Weka::Core::Attribute.new('date', 'yyyy-MM-dd HH:mm')
      expect(attribute.internal_value_of('2015-12-24 11:11')).to eq 1450951860000.0
    end
  end
end