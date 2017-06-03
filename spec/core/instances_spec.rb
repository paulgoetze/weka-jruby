require 'spec_helper'
require 'fileutils'
require 'matrix'

describe Weka::Core::Instances do
  let(:class_attribute_name) { :windy }

  subject { load_instances('weather.arff') }

  it { is_expected.to respond_to :each }
  it { is_expected.to respond_to :each_with_index }
  it { is_expected.to respond_to :each_attribute }
  it { is_expected.to respond_to :each_attribute_with_index }

  it { is_expected.to respond_to :to_arff }
  it { is_expected.to respond_to :to_csv }
  it { is_expected.to respond_to :to_json }

  it { is_expected.to respond_to :numeric }
  it { is_expected.to respond_to :nominal }
  it { is_expected.to respond_to :string }
  it { is_expected.to respond_to :date }

  it { is_expected.to respond_to :attributes }
  it { is_expected.to respond_to :instances }
  it { is_expected.to respond_to :attribute_names }

  it { is_expected.to respond_to :add_instance }
  it { is_expected.to respond_to :apply_filter }
  it { is_expected.to respond_to :apply_filters }
  it { is_expected.to respond_to :merge }

  it { is_expected.to respond_to :class_attribute= }
  it { is_expected.to respond_to :class_attribute }
  it { is_expected.to respond_to :reset_class_attribute }

  it { is_expected.to respond_to :serialize }
  it { is_expected.to respond_to :to_m }

  describe 'aliases:' do
    let(:instances) { described_class.new }

    {
      numeric:                :add_numeric_attribute,
      string:                 :add_string_attribute,
      nominal:                :add_nominal_attribute,
      date:                   :add_date_attribute,
      add_attributes:         :with_attributes,
      instances_count:        :num_instances,
      attributes_count:       :num_attributes,
      has_string_attribute?:  :check_for_string_attributes
    }.each do |method, alias_method|
      it "defines the alias ##{alias_method} for ##{method}" do
        expect(instances.method(method)).to eq instances.method(alias_method)
      end
    end
  end

  describe 'loader' do
    [:arff, :csv, :json].each do |type|
      before do
        allow(Weka::Core::Loader).to receive(:"load_#{type}").and_return('')
      end

      describe ".from_#{type}" do
        it "calls Weka::Core::Loader#load_#{type}" do
          expect(Weka::Core::Loader)
            .to receive(:"load_#{type}").once
            .with("test.#{type}")

          described_class.send("from_#{type}", "test.#{type}")
        end
      end
    end

    describe '.from_c45' do
      let(:file) { 'example.data' }

      before { allow(Weka::Core::Loader).to receive(:load_c45).and_return('') }

      it 'calls Weka::Core::Loader#load_c45' do
        expect(Weka::Core::Loader)
          .to receive(:load_c45).once
          .with(file)

        described_class.send(:from_c45, file)
      end
    end
  end

  describe 'saver' do
    [:arff, :csv, :json].each do |type|
      before do
        allow(Weka::Core::Saver).to receive(:"save_#{type}").and_return('')
      end

      describe "#to_#{type}" do
        it "calls the Weka::Core::Saver.save_#{type}" do
          expect(Weka::Core::Saver)
            .to receive(:"save_#{type}").once
            .with(file: "test.#{type}", instances: subject)

          subject.send("to_#{type}", "test.#{type}")
        end
      end
    end

    describe '#to_c45' do
      let(:file) { 'test.names' }

      before do
        allow(Weka::Core::Saver).to receive(:save_c45).and_return('')
      end

      it 'calls the Weka::Core::Saver.save_c45' do
        expect(Weka::Core::Saver)
          .to receive(:save_c45).once
          .with(file: file, instances: subject)

        subject.to_c45(file)
      end
    end
  end

  describe '#instances' do
    it 'returns an Array of DenseInstance objects' do
      objects = subject.instances
      expect(objects).to be_an Array

      all_kind_of_instance = objects.reduce(true) do |result, object|
        result && object.is_a?(Java::WekaCore::DenseInstance)
      end

      expect(all_kind_of_instance).to be true
    end
  end

  describe '#attributes' do
    it 'returns an Array of Attribute objects' do
      objects = subject.attributes
      expect(objects).to be_an Array

      all_kind_of_attribute = objects.reduce(true) do |result, object|
        result && object.is_a?(Java::WekaCore::Attribute)
      end

      expect(all_kind_of_attribute).to be true
    end

    context 'when class attribute is not set' do
      it 'returns all attributes' do
        expect(subject.attributes.size).to eq subject.attributes_count
        expect(subject.attributes(include_class_attribute: true).size)
          .to eq subject.attributes_count
      end
    end

    context 'when class attribute is set' do
      before { subject.class_attribute = class_attribute_name }

      it 'returns all attributes if include_class_attribute is true' do
        expect(subject.attributes(include_class_attribute: true).size)
          .to eq subject.attributes_count
      end

      it 'skips the class attribute if include_class_attribute is false' do
        expect(subject.attributes.size).to eq(subject.attributes_count-1)
      end
    end
  end

  describe '#attribute_names' do
    names = %w(outlook temperature humidity windy play)

    it 'returns an Array of the attribute names' do
      expect(subject.attribute_names).to eq names
    end

    context 'when class attribute is set' do
      before { subject.class_attribute = class_attribute_name }

      it 'skips the class attribute if include_class_attribute is false' do
        expect(subject.attribute_names)
          .not_to include subject.class_attribute.name
      end

      it 'returns all attributes if include_class_attribute is true' do
        expect(subject.attribute_names(include_class_attribute: true))
          .to include subject.class_attribute.name
      end
    end
  end

  describe 'attribute definers:' do
    let(:instances) { described_class.new }
    let(:name)      { 'attribute_name' }

    describe '#numeric' do
      it 'can be used to add a numeric attribute' do
        instances.numeric(name)
        expect(instances.attributes.first).to be_numeric
      end

      context 'with the class_attribute option' do
        it 'defines the attribute as class attribute' do
          instances.numeric(name, class_attribute: true)
          expect(instances.class_attribute.name).to eq name
        end
      end
    end

    describe '#string' do
      it 'can be used to add a string attribute' do
        instances.string(name)
        expect(instances.attributes.first).to be_string
      end

      context 'with the class_attribute option' do
        it 'defines the attribute as class attribute' do
          instances.string(name, class_attribute: true)
          expect(instances.class_attribute.name).to eq name
        end
      end
    end

    describe '#nominal' do
      it 'can be used to add a nominal attribute' do
        instances.nominal(name, values: %w(yes no))
        expect(instances.attributes.first).to be_nominal
      end

      context 'with the class_attribute option' do
        it 'defines the attribute as class attribute' do
          instances.nominal(name, values: %w(yes no), class_attribute: true)
          expect(instances.class_attribute.name).to eq name
        end
      end
    end

    describe '#date' do
      it 'can be used to add a date attribute' do
        instances.date(name)
        expect(instances.attributes.first).to be_date
      end

      context 'with the class_attribute option' do
        it 'defines the attribute as class attribute' do
          instances.date(name, class_attribute: true)
          expect(instances.class_attribute.name).to eq name
        end
      end
    end

    context 'called with symbols' do
      describe '#numeric' do
        it 'can be used to add a numeric attribute' do
          instances.numeric(:attribute_name)
          expect(instances.attributes.first).to be_numeric
        end
      end

      describe '#string' do
        it 'can be used to add a string attribute' do
          instances.string(:attribute_name)
          expect(instances.attributes.first).to be_string
        end
      end

      describe '#nominal' do
        it 'can be used to add a nominal attribute' do
          instances.nominal(:attribute_name, values: [:yes, :no])
          expect(instances.attributes.first).to be_nominal
        end

        it 'converts a single option into an Array' do
          instances.nominal(:attribute_name, values: 'yes')
          expect(instances.attributes.first.values).to eq ['yes']
        end

        it 'converts the options into strings' do
          instances.nominal(:attribute_name, values: [true, false])
          expect(instances.attributes.first.values).to eq %w(true false)
        end
      end

      describe '#date' do
        it 'can be used to add a date attribute' do
          instances.date(:attribute_name)
          expect(instances.attributes.first).to be_date
        end
      end
    end
  end

  describe '#class_attribute=' do
    it 'can be used to define the class attribute' do
      subject.class_attribute = :play
      expect(subject.class_attribute.name).to eq 'play'
    end

    it 'resets the class attribute if it assigns nil' do
      subject.class_attribute = :play

      expect { subject.class_attribute = nil }
        .to change { subject.class_attribute }
        .from(an_instance_of(Weka::Core::Attribute))
        .to(nil)
    end

    it 'raises an ArgumentError if the given attribute is not defined' do
      expect { subject.class_attribute = :not_existing_attribute }
        .to raise_error(ArgumentError)
    end

    context 'when class attribute is already set' do
      before { subject.class_attribute = class_attribute_name }

      it 'can set the same attribute as class attribute again' do
        subject.class_attribute = class_attribute_name
        expect(subject.class_attribute.name).to eq class_attribute_name.to_s
      end

      it 'can set another attribute as class attribute' do
        subject.class_attribute = :play
        expect(subject.class_attribute.name).to eq :play.to_s
      end
    end
  end

  describe '#class_attribute' do
    context 'if class attribute is set' do
      before { subject.class_attribute = :play }

      it 'returns the Attribute' do
        expect(subject.class_attribute).to be_kind_of Weka::Core::Attribute
        expect(subject.class_attribute.name).to eq 'play'
      end
    end

    context 'if class attribute is not set' do
      it 'does not raise a Java::WekaCore::UnassignedClassException' do
        expect { subject.class_attribute }.not_to raise_error
      end

      it 'returns nil' do
        expect(subject.class_attribute).to be_nil
      end
    end
  end

  describe '#class_attribute_defined?' do
    context 'if class_attribute is set' do
      before { subject.class_attribute = :outlook }

      it 'returns true' do
        expect(subject.class_attribute_defined?).to be true
      end
    end

    context 'if class_attribute is not set' do
      it 'returns false' do
        expect(subject.class_attribute_defined?).to be false
      end
    end
  end

  describe '#reset_class_attribute' do
    before { subject.class_attribute = :play }

    it 'resets the class attribute' do
      expect { subject.reset_class_attribute }
        .to change { subject.class_attribute }.to(nil)
    end
  end

  describe '#add_attributes' do
    it 'adds the numbers of attributes given in the block' do
      instances = Weka::Core::Instances.new

      expect do
        instances.add_attributes do
          numeric 'attribute'
          nominal 'class', values: %w(YES NO)
        end
      end.to change { instances.attributes.count }.from(0).to(2)
    end

    it 'adds the types of attributes given in the block' do
      instances = Weka::Core::Instances.new

      instances.add_attributes do
        numeric 'attribute'
        nominal 'class', values: %w(YES NO)
      end

      expect(instances.attributes.map(&:name)).to eq %w(attribute class)
    end
  end

  describe '#initialize' do
    it 'takes a relation_name as argument' do
      name      = 'name'
      instances = Weka::Core::Instances.new(relation_name: name)

      expect(instances.relation_name).to eq name
    end

    it 'has a default relation_name of "Instances"' do
      expect(Weka::Core::Instances.new.relation_name).to eq 'Instances'
    end

    it 'takes attributes as argument' do
      attributes = subject.attributes
      instances  = Weka::Core::Instances.new(attributes: attributes)

      expect(instances.attributes.count).to eq attributes.count
    end
  end

  describe 'enumerator' do
    before { @result = nil }

    describe '#each' do
      it 'runs a block on each instance' do
        subject.each do |instance|
          @result = instance.value(0) unless @result
        end

        expect(@result).to eq 0.0 # index of nominal value
      end

      context 'without a given block' do
        it 'returns a WekaEnumerator' do
          expect(subject.each)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end

    describe '#each_with_index' do
      it 'runs a block on each instance' do
        subject.each_with_index do |instance, index|
          @result = "#{instance.value(0)}, #{index}" if index.zero?
        end

        expect(@result).to eq '0.0, 0' # 0.0 => index of nominal value
      end

      context 'without a given block' do
        it 'returns a WekaEnumerator' do
          expect(subject.each_with_index)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end

    describe '#each_attribute' do
      it 'runs a block on each attribute' do
        subject.each_attribute do |attribute|
          @result = attribute.name unless @result
        end

        expect(@result).to eq 'outlook'
      end

      context 'without a given block' do
        it 'returns a WekaEnumerator' do
          expect(subject.each_attribute)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end

    describe '#each_attribute_with_index' do
      it 'runs a block on each attribute' do
        subject.each_attribute_with_index do |attribute, index|
          @result = "#{attribute.name}, #{index}" if index.zero?
        end

        expect(@result).to eq 'outlook, 0'
      end

      context 'without a given block' do
        it 'returns a WekaEnumerator' do
          expect(subject.each_attribute_with_index)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end
  end

  describe '#add_instance' do
    context 'when passing an array of attribute values' do
      it 'adds an instance from given values to the Instances object' do
        data = [:sunny, 70, 80, 'TRUE', :yes]
        subject.add_instance(data)

        expect(subject.instances.last.to_s).to eq data.join(',')
      end

      it 'adds a given instance to the Instances object' do
        data = subject.first
        subject.add_instance(data)

        expect(subject.instances.last.to_s).to eq data.to_s
      end

      it 'adds a given instance with only missing values' do
        data = Weka::Core::DenseInstance.new(subject.size)
        subject.add_instance(data)
        expect(subject.instances.last.to_s).to eq data.to_s
      end

      it 'adds a given instance with partly missing values' do
        data = [:sunny, 70, nil, '?', Float::NAN]
        subject.add_instance(data)

        expect(subject.instances.last.to_s).to eq 'sunny,70,?,?,?'
      end
    end

    context 'when passing a hash of attribute values' do
      let(:humidity_value) { 80 }
      let(:windy_value)    { 'TRUE' }
      let(:play_value)     { :yes }

      let(:data) do
        {
          outlook: :sunny,
          temperature: 70,
          humidity: humidity_value,
          windy: windy_value,
          play: play_value
        }
      end

      it 'adds an instance from given values to the Instances object' do
        subject.add_instance(data)
        expect(subject.instances.last.to_s).to eq data.values.join(',')
      end

      context 'when some attribute values are missing' do
        let(:humidity_value) { nil }
        let(:windy_value)    { '?' }
        let(:play_value)     { Float::NAN }

        it 'adds a given instance with partly missing values' do
          subject.add_instance(data)
          expect(subject.instances.last.to_s).to eq 'sunny,70,?,?,?'
        end
      end

      context 'when class attribute is set' do
        before { subject.class_attribute = class_attribute_name }

        it 'adds a given instance to the Instances object' do
          subject.add_instance(data)
          expect(subject.instances.last.to_s).to eq data.values.join(',')
        end
      end
    end
  end

  describe '#add_instances' do
    let(:data) do
      [[:sunny, 70, 80, :TRUE, :yes], [:overcast, 80, 85, :FALSE, :yes]]
    end

    context 'when each instance is stored as an array of attribute values' do
      it 'adds the data to the Instances object' do
        expect { subject.add_instances(data) }
          .to change { subject.instances_count }
          .by(data.count)
      end
    end

    context 'when each instance is stored as a hash of attribute values' do
      let(:hash_data) do
        names = subject
          .attribute_names(include_class_attribute: true)
          .map(&:to_sym)

        data.map do |attribute_values|
          names.each_with_index.inject({}) do |hash, (name, index)|
            hash.update(name => attribute_values[index])
          end
        end
      end

      it 'adds the data to the Instances object' do
        expect { subject.add_instances(hash_data) }
          .to change { subject.instances_count }
          .by(hash_data.count)
      end
    end

    it 'calls #add_instance internally' do
      expect(subject).to receive(:add_instance).exactly(data.count).times
      subject.add_instances(data)
    end
  end

  describe '#internal_values_of' do
    context 'when passing an array' do
      it 'returns an array of internal values of the given values' do
        values = [:sunny, 85, 85, :FALSE, :no]
        internal_values = [0, 85.0, 85.0, 1, 1]

        expect(subject.internal_values_of(values)).to eq internal_values
      end
    end

    context 'when passing a hash' do
      let(:values) do
        {
          outlook: :sunny,
          temperature: 85,
          humidity: 85,
          windy: :FALSE,
          play: :no
        }
      end

      let(:internal_values) do
        {
          outlook: 0,
          temperature: 85.0,
          humidity: 85.0,
          windy: 1,
          play: 1
        }
      end

      it 'returns a hash of internal values of the given values' do
        expect(subject.internal_values_of(values)).to eq internal_values
      end

      context 'when class attribute is set' do
        before { subject.class_attribute = class_attribute_name }

        it 'returns a hash of internal values of the given values' do
          expect(subject.internal_values_of(values)).to eq internal_values
        end
      end
    end
  end

  describe '#apply_filter' do
    let(:filter) { double('filter') }
    before { allow(filter).to receive(:filter).and_return(subject) }

    it 'calls the given filter’s #filter method' do
      expect(filter).to receive(:filter).once.with(subject)
      subject.apply_filter(filter)
    end
  end

  describe '#apply_filters' do
    let(:filter) { double('filter') }
    before { allow(filter).to receive(:filter).and_return(subject) }

    it 'calls the given filters’s #filter methods' do
      expect(filter).to receive(:filter).twice.with(subject)
      subject.apply_filters(filter, filter)
    end
  end

  describe '#merge' do
    let(:attribute_a) { subject.attributes[0] }
    let(:attribute_b) { subject.attributes[1] }
    let(:attribute_c) { subject.attributes[2] }

    let(:instances_a) { Weka::Core::Instances.new(attributes: [attribute_a]) }
    let(:instances_b) { Weka::Core::Instances.new(attributes: [attribute_b]) }
    let(:instances_c) { Weka::Core::Instances.new(attributes: [attribute_c]) }

    context 'when merging one instances object' do
      it 'calls .merge_instance of Weka::Core::Instances' do
        expect(Weka::Core::Instances)
          .to receive(:merge_instances)
          .with(instances_a, instances_b)

        instances_a.merge(instances_b)
      end

      it 'returns the result of .merge_instance' do
        merged = double('instances')

        allow(Weka::Core::Instances)
          .to receive(:merge_instances)
          .and_return(merged)

        expect(instances_a.merge(instances_b)).to eq merged
      end
    end

    context 'when merging multiple instances' do
      it 'calls .merge_instances mutliple times' do
        expect(Weka::Core::Instances).to receive(:merge_instances).twice
        instances_a.merge(instances_b, instances_c)
      end

      it 'returns the merged instances' do
        merged            = instances_a.merge(instances_b, instances_c)
        merged_attributes = [attribute_a, attribute_b, attribute_c]

        expect(merged.attributes).to match_array merged_attributes
      end
    end
  end

  describe '#has_string_attribute?' do
    context 'if no string attribute exists' do
      it 'returns false' do
        expect(subject.has_string_attribute?).to be false
      end
    end

    context 'if dataset has string attribute' do
      subject { load_instances('weather.string.arff') }

      it 'returns true' do
        expect(subject.has_string_attribute?).to be true
      end
    end
  end

  describe '#has_attribute_type?' do
    subject    { load_instances('weather.string.arff') }
    let(:type) { 'nominal' }

    it 'calls the underlying Java method .check_for_attribute_type' do
      expect(subject)
        .to receive(:check_for_attribute_type)
        .with(subject.send(:map_attribute_type, type))

      subject.has_attribute_type?(type)
    end

    context 'when given String argument' do
      Weka::Core::Attribute::TYPES.map(&:to_s).each do |type|
        if type == 'date'
          it 'returns false if the attribute type does not exist' do
            expect(subject.has_attribute_type?(type)).to be false
          end
        else
          it 'returns true if the attribute type exists' do
            expect(subject.has_attribute_type?(type)).to be true
          end
        end
      end

      it 'handles attribute type in uppercase' do
        expect(subject.has_attribute_type?('STRING')).to be true
      end

      it 'returns false for undefined attribute type' do
        expect(subject.has_attribute_type?('I_DO_NOT_EXIST')).to be false
      end
    end

    context 'when given Symbol argument' do
      Weka::Core::Attribute::TYPES.each do |type|
        if type == :date
          it 'returns false if the attribute type does not exist' do
            expect(subject.has_attribute_type?(type)).to be false
          end
        else
          it 'returns true if the attribute type exists' do
            expect(subject.has_attribute_type?(type)).to be true
          end
        end
      end

      it 'handles attribute type in uppercase' do
        expect(subject.has_attribute_type?(:STRING)).to be true
      end

      it 'returns false for undefined attribute type' do
        expect(subject.has_attribute_type?(:I_DO_NOT_EXIST)).to be false
      end
    end

    context 'when given Integer argument' do
      attribute_types = [
        Weka::Core::Attribute::NUMERIC,
        Weka::Core::Attribute::NOMINAL,
        Weka::Core::Attribute::STRING,
        Weka::Core::Attribute::DATE
      ]

      attribute_types.each do |type|
        if type == Weka::Core::Attribute::DATE
          it 'returns false if the attribute type does not exist' do
            expect(subject.has_attribute_type?(type)).to be false
          end
        else
          it 'returns true if the attribute type exists' do
            expect(subject.has_attribute_type?(type)).to be true
          end
        end
      end

      it 'returns false for undefined attribute type' do
        expect(subject.has_attribute_type?(-1)).to be false
      end
    end
  end

  describe '#to_m' do
    subject { load_instances('weather.arff') }

    it 'returns a matrix of all instance values' do
      matrix = Matrix[
        ['sunny', 85.0, 85.0, 'FALSE', 'no'],
        ['sunny', 80.0, 90.0, 'TRUE', 'no'],
        ['overcast', 83.0, 86.0, 'FALSE', 'yes'],
        ['rainy', 70.0, 96.0, 'FALSE', 'yes'],
        ['rainy', 68.0, 80.0, 'FALSE', 'yes'],
        ['rainy', 65.0, 70.0, 'TRUE', 'no'],
        ['overcast', 64.0, 65.0, 'TRUE', 'yes'],
        ['sunny', 72.0, 95.0, 'FALSE', 'no'],
        ['sunny', 69.0, 70.0, 'FALSE', 'yes'],
        ['rainy', 75.0, 80.0, 'FALSE', 'yes'],
        ['sunny', 75.0, 70.0, 'TRUE', 'yes'],
        ['overcast', 72.0, 90.0, 'TRUE', 'yes'],
        ['overcast', 81.0, 75.0, 'FALSE', 'yes'],
        ['rainy', 71.0, 91.0, 'TRUE', 'no']
      ]

      expect(subject.to_m).to eq matrix
    end
  end
end
