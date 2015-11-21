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
    context 'a numeric attribute' do
      let(:attribute) { Weka::Core::Attribute.new('numeric attribute') }

      it 'should return the value as a float' do
        expect(attribute.internal_value_of(3.5)).to   eq 3.5
      end

      it 'should return the value as a float if given as string' do
        expect(attribute.internal_value_of('3.5')).to eq 3.5
      end
    end

    context 'a nominal attribute' do
      let(:attribute) { Weka::Core::Attribute.new('class', ['true', 'false']) }

      it 'should return the correct internal index' do
        expect(attribute.internal_value_of('true')).to  eq 0
        expect(attribute.internal_value_of('false')).to eq 1
      end

      it 'should return the correct internal index as given as a non-String' do
        expect(attribute.internal_value_of(true)).to eq 0
        expect(attribute.internal_value_of(false)).to eq 1

        expect(attribute.internal_value_of(:true)).to eq 0
        expect(attribute.internal_value_of(:false)).to eq 1
      end
    end

    context 'a data attribute' do
      let(:attribute) { Weka::Core::Attribute.new('date', 'yyyy-MM-dd HH:mm') }

      it 'should return the right date timestamp value' do
        expect(attribute.internal_value_of('2015-12-24 11:11')).to eq 1450951860000.0
      end
    end
  end
end