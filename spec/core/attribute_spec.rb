require 'spec_helper'

describe Weka::Core::Attribute do
  let(:values) { %w(true false) }
  let(:name)   { 'name' }
  let(:format) { 'yyyy-MM-dd HH:mm' }

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
    subject { Weka::Core::Attribute.new_date(name, format) }

    it 'returns a date Attribute' do
      expect(subject.date?).to be true
    end

    it 'returns an Attribute with the given name' do
      expect(subject.name).to eq name
    end
  end

  describe '.new_string' do
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
    context 'for a numeric attribute' do
      subject { Weka::Core::Attribute.new_numeric(name) }

      it 'returns the value as a float' do
        expect(subject.internal_value_of(3.5)).to eq 3.5
      end

      it 'returns the value as a float if given as string' do
        expect(subject.internal_value_of('3.5')).to eq 3.5
      end

      it 'returns NaN if the given value is Float::NAN' do
        expect(subject.internal_value_of(Float::NAN)).to be Float::NAN
      end

      it 'returns NaN if the given value is nil' do
        expect(subject.internal_value_of(nil)).to be Float::NAN
      end

      it 'returns NaN if the given value is "?"' do
        expect(subject.internal_value_of('?')).to be Float::NAN
      end
    end

    context 'for a nominal attribute' do
      subject { Weka::Core::Attribute.new_nominal(name, values) }

      it 'returns the correct internal index' do
        expect(subject.internal_value_of('true')).to  eq 0
        expect(subject.internal_value_of('false')).to eq 1
      end

      it 'returns the correct internal index as given as a non-String' do
        expect(subject.internal_value_of(true)).to eq 0
        expect(subject.internal_value_of(false)).to eq 1

        expect(subject.internal_value_of(:true)).to eq 0
        expect(subject.internal_value_of(:false)).to eq 1
      end

      it 'returns NaN if the given value is Float::NAN' do
        expect(subject.internal_value_of(Float::NAN)).to be Float::NAN
      end

      it 'returns NaN if the given value is nil' do
        expect(subject.internal_value_of(nil)).to be Float::NAN
      end

      it 'returns NaN if the given value is "?"' do
        expect(subject.internal_value_of('?')).to be Float::NAN
      end
    end

    context 'for a data attribute' do
      let(:datetime)       { '2015-12-24 11:11' }
      let(:unix_timestamp) { 1_450_955_460_000.0 }

      subject { Weka::Core::Attribute.new_date(name, format) }

      before do
        allow(subject)
          .to receive(:parse_date)
          .with(datetime)
          .and_return(unix_timestamp)
      end

      it 'returns the right date timestamp value' do
        expect(subject.internal_value_of(datetime)).to eq unix_timestamp
      end

      it 'returns NaN if the given value is Float::NAN' do
        expect(subject.internal_value_of(Float::NAN)).to be Float::NAN
      end

      it 'returns NaN if the given value is nil' do
        expect(subject.internal_value_of(nil)).to be Float::NAN
      end

      it 'returns NaN if the given value is "?"' do
        expect(subject.internal_value_of('?')).to be Float::NAN
      end
    end
  end

  describe '#type' do
    context 'for a numeric attribute' do
      subject { Weka::Core::Attribute.new_numeric(name) }

      it 'returns "numeric"' do
        expect(subject.type).to eq 'numeric'
      end
    end

    context 'for a nominal attribute' do
      subject { Weka::Core::Attribute.new_nominal(name, values) }

      it 'returns "nominal"' do
        expect(subject.type).to eq 'nominal'
      end
    end

    context 'for a string attribute' do
      subject { Weka::Core::Attribute.new_string(name) }

      it 'returns "string"' do
        expect(subject.type).to eq 'string'
      end
    end

    context 'for a data attribute' do
      let(:datetime)       { '2015-12-24 11:11' }
      let(:unix_timestamp) { 1_450_955_460_000.0 }

      subject { Weka::Core::Attribute.new_date(name, format) }

      before do
        allow(subject)
          .to receive(:parse_date)
          .with(datetime)
          .and_return(unix_timestamp)
      end

      it 'returns "date"' do
        expect(subject.type).to eq 'date'
      end
    end
  end
end
