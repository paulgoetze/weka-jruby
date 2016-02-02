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

  describe 'instantiation' do
    describe 'with an Integer value' do
      it 'should create a instance with only missing values' do
        values = Weka::Core::DenseInstance.new(2).values
        expect(values).to eq ['?', '?']
      end
    end

    describe 'with an array' do
      it 'should create an instance with the given values' do
        values = Weka::Core::DenseInstance.new([1, 2, 3]).values
        expect(values).to eq [1, 2, 3]
      end

      it 'should handle "?" values or nil values' do
        values = Weka::Core::DenseInstance.new([1, '?', nil, 4]).values
        expect(values).to eq [1, '?', '?', 4]
      end
    end
  end

  describe '#to_a' do
    let(:values) { ['rainy',50.0, 50.0,'TRUE','no','2015-12-24 11:11'] }

    it 'should return an Array with the values of the instance' do
      expect(subject.to_a).to eq values
    end

    context 'with a set class attribute' do
      subject do
        instances = load_instances('weather.arff')
        instances.add_date_attribute('recorded_at')
        instances.add_instance(values)
        instances.class_attribute = :play
        instances.instances.last
      end

      it 'should return an Array with the values of the instance' do
        expect(subject.to_a).to eq values
      end
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