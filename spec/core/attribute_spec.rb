require 'spec_helper'

describe Weka::Core::Attribute do
  let(:values) { %w(yes no) }
  let(:name)   { 'name' }

  subject { Weka::Core::Attribute.new(name, values) }

  it { is_expected.to respond_to :values }
  it { is_expected.to respond_to :internal_value_of }

  describe '.new_numeric' do
    subject { Weka::Core::Attribute.new_numeric(name) }

    it 'returns a numeric Attribute' do
      expect(subject.numeric?).to be true
    end

    it 'returns an Attribute with the given name' do
      expect(subject.name).to eq name
    end
  end

  describe '.new_nominal' do
    subject { Weka::Core::Attribute.new_nominal(name, values) }

    it 'returns a nominal Attribute' do
      expect(subject.nominal?).to be true
    end

    it 'returns an Attribute with the given name' do
      expect(subject.name).to eq name
    end
  end

  describe '.new_date' do
    subject { Weka::Core::Attribute.new_date(name, 'yyyy-MM-dd HH:mm') }

    it 'returns a date Attribute' do
      expect(subject.date?).to be true
    end

    it 'returns an Attribute with the given name' do
      expect(subject.name).to eq name
    end
  end

  xdescribe '.new_string' do
    subject { Weka::Core::Attribute.new_string(name) }

    it 'returns a string Attribute' do
      expect(subject.string?).to be true
    end

    it 'returns an Attribute with the given name' do
      expect(subject.name).to eq name
    end
  end

  describe '#values' do
    it 'returns an array of the values' do
      expect(subject.values).to eq values
    end
  end

  describe '#internal_value_of' do
    context 'a numeric attribute' do
      let(:attribute) { Weka::Core::Attribute.new('numeric attribute') }

      it 'returns the value as a float' do
        expect(attribute.internal_value_of(3.5)).to eq 3.5
      end

      it 'returns the value as a float if given as string' do
        expect(attribute.internal_value_of('3.5')).to eq 3.5
      end

      it 'returns NaN if the given value is Float::NAN' do
        expect(attribute.internal_value_of(Float::NAN)).to be Float::NAN
      end

      it 'returns NaN if the given value is nil' do
        expect(attribute.internal_value_of(nil)).to be Float::NAN
      end

      it 'returns NaN if the given value is "?"' do
        expect(attribute.internal_value_of('?')).to be Float::NAN
      end
    end

    context 'a nominal attribute' do
      let(:attribute) { Weka::Core::Attribute.new('class', %w(true false)) }

      it 'returns the correct internal index' do
        expect(attribute.internal_value_of('true')).to  eq 0
        expect(attribute.internal_value_of('false')).to eq 1
      end

      it 'returns the correct internal index as given as a non-String' do
        expect(attribute.internal_value_of(true)).to eq 0
        expect(attribute.internal_value_of(false)).to eq 1

        expect(attribute.internal_value_of(:true)).to eq 0
        expect(attribute.internal_value_of(:false)).to eq 1
      end

      it 'returns NaN if the given value is Float::NAN' do
        expect(attribute.internal_value_of(Float::NAN)).to be Float::NAN
      end

      it 'returns NaN if the given value is nil' do
        expect(attribute.internal_value_of(nil)).to be Float::NAN
      end

      it 'returns NaN if the given value is "?"' do
        expect(attribute.internal_value_of('?')).to be Float::NAN
      end
    end

    context 'a data attribute' do
      let(:attribute)      { Weka::Core::Attribute.new('date', 'yyyy-MM-dd HH:mm') }
      let(:datetime)       { '2015-12-24 11:11' }
      let(:unix_timestamp) { 1_450_955_460_000.0 }

      before do
        allow(attribute)
          .to receive(:parse_date)
          .with(datetime)
          .and_return(unix_timestamp)
      end

      it 'returns the right date timestamp value' do
        expect(attribute.internal_value_of(datetime)).to eq unix_timestamp
      end

      it 'returns NaN if the given value is Float::NAN' do
        expect(attribute.internal_value_of(Float::NAN)).to be Float::NAN
      end

      it 'returns NaN if the given value is nil' do
        expect(attribute.internal_value_of(nil)).to be Float::NAN
      end

      it 'returns NaN if the given value is "?"' do
        expect(attribute.internal_value_of('?')).to be Float::NAN
      end
    end
  end
end
