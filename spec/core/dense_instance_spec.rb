require 'spec_helper'

describe Weka::Core::DenseInstance do

  subject do
    instances = load_instances('weather.arff')
    instances.add_date_attribute('recorded_at')
    instances.add_instance(['rainy',50, 50,'TRUE','no','2015-12-24 11:11'])
    instances.instances.last
  end

  it { is_expected.to respond_to :to_a }
  it { is_expected.to respond_to :attributes }
  it { is_expected.to respond_to :each_attribute }
  it { is_expected.to respond_to :each_attribute_with_index }

  describe 'aliases:' do
    {
      values:       :to_a,
      values_count: :num_values
    }.each do |method, alias_method|
      it "should define the alias ##{alias_method} for ##{method}" do
        expect(subject.method(method)).to eq subject.method(alias_method)
      end
    end
  end

  describe '#to_a' do
    it 'should return an Array with the values of the instance' do
      values = ['rainy',50.0, 50.0,'TRUE','no','2015-12-24 11:11']
      expect(subject.to_a).to eq values
    end
  end

  describe '#attributes' do
    it 'should return an Array of Attributes' do
      attributes = subject.attributes
      expect(attributes).to be_an Array

      all_kind_of_attribute = attributes.reduce(true) do |result, attribute|
        result &&= attribute.kind_of?(Java::WekaCore::Attribute)
      end

      expect(all_kind_of_attribute).to be true
    end
  end

  describe 'enumerator' do
    before { @result = nil }

    describe '#each_attribute' do
      it 'should run a block on each attribute' do
        subject.each_attribute do |attribute|
          @result = attribute.name unless @result
        end

        expect(@result).to eq 'outlook'
      end

      context 'without a given block' do
        it 'should return a WekaEnumerator' do
          expect(subject.each_attribute)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end

    describe '#each_attribute_with_index' do
      it 'should run a block on each attribute' do
        subject.each_attribute_with_index do |attribute, index|
          @result = "#{attribute.name}, #{index}" if index == 0
        end

        expect(@result).to eq 'outlook, 0'
      end

      context 'without a given block' do
        it 'should return a WekaEnumerator' do
          expect(subject.each_attribute_with_index)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end
  end

end