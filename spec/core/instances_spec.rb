require 'spec_helper'
require 'fileutils'

describe Weka::Core::Instances do

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

  describe 'aliases:' do
    let (:instances) { described_class.new }

    {
      numeric:             :add_numeric_attribute,
      string:              :add_string_attribute,
      nominal:             :add_nominal_attribute,
      date:                :add_date_attribute,
      add_attributes:      :with_attributes,
      instances_count:     :num_instances,
      attributes_count:    :num_attributes
    }.each do |method, alias_method|
      it "should define the alias ##{alias_method} for ##{method}" do
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
        it "should call the Weka::Core::Loader#load_#{type}" do
          expect(Weka::Core::Loader)
            .to receive(:"load_#{type}").once
            .with("test.#{type}")

          described_class.send("from_#{type}", "test.#{type}")
        end
      end
    end
  end

  describe 'saver' do
    [:arff, :csv, :json].each do |type|
      before do
        allow(Weka::Core::Saver).to receive(:"save_#{type}").and_return('')
      end

      describe "#to_#{type}" do
        it "should call the Weka::Core::Saver#save_#{type}" do
          expect(Weka::Core::Saver)
            .to receive(:"save_#{type}").once
            .with(file: "test.#{type}", instances: subject)

          subject.send("to_#{type}", "test.#{type}")
        end
      end
    end
  end

  describe '#instances' do
    it 'should return an Array of DenseInstance objects' do
      objects = subject.instances
      expect(objects).to be_an Array

      all_kind_of_instance = objects.reduce(true) do |result, object|
        result &&= object.kind_of?(Java::WekaCore::DenseInstance)
      end

      expect(all_kind_of_instance).to be true
    end
  end

  describe '#attributes' do
    it 'should return an Array of Attribute objects' do
      objects = subject.attributes
      expect(objects).to be_an Array

      all_kind_of_attribute = objects.reduce(true) do |result, object|
        result &&= object.kind_of?(Java::WekaCore::Attribute)
      end

      expect(all_kind_of_attribute).to be true
    end
  end

  describe '#attribute_names' do
    it 'should return an Array of the attribute names' do
      names = %w{ outlook temperature humidity windy play }
      expect(subject.attribute_names).to eq names
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
        it 'should define the attribute as class attribute' do
          instances.numeric(name, class_attribute: true)
          expect(instances.class_attribute.name).to eq name
        end
      end
    end

    xdescribe '#string' do
      it 'can be used to add a string attribute' do
        instances.string(name)
        expect(instances.attributes.first).to be_string
      end
    end

    describe '#nominal' do
      it 'can be used to add a nominal attribute' do
        instances.nominal(name, values: ['yes', 'no'])
        expect(instances.attributes.first).to be_nominal
      end

      context 'with the class_attribute option' do
        it 'should define the attribute as class attribute' do
          instances.nominal(name, values: ['yes', 'no'], class_attribute: true)
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
        it 'should define the attribute as class attribute' do
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

      xdescribe '#string' do
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

        it 'should convert a single option into an Array' do
          instances.nominal(:attribute_name, values: 'yes')
          expect(instances.attributes.first.values).to eq ['yes']
        end

        it 'should convert the options into strings' do
          instances.nominal(:attribute_name, values: [true, false])
          expect(instances.attributes.first.values).to eq ['true', 'false']
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

    it 'should reset the class attribute if it assigns nil' do
      subject.class_attribute = :play

      expect { subject.class_attribute = nil }
        .to change { subject.class_attribute }
        .from(an_instance_of(Weka::Core::Attribute))
        .to(nil)
    end

    it 'should raise an ArgumentError if the given attribute is not defined' do
      expect { subject.class_attribute = :not_existing_attribute }
        .to raise_error(ArgumentError)
    end
  end

  describe '#class_attribute' do
    context 'if class attribute is set' do
      before { subject.class_attribute = :play }

      it 'should return the Attribute' do
        expect(subject.class_attribute).to be_kind_of Weka::Core::Attribute
        expect(subject.class_attribute.name).to eq 'play'
      end
    end

    context 'if class attribute is not set' do
      it 'should not raise a Java::WekaCore::UnassignedClassException' do
        expect { subject.class_attribute }
          .not_to raise_error Java::WekaCore::UnassignedClassException
      end

      it 'should return nil' do
        expect(subject.class_attribute).to be_nil
      end
    end
  end

  describe '#class_attribute_defined?' do
    context 'if class_attribute is set' do
      before { subject.class_attribute = :outlook }

      it 'should return true' do
        expect(subject.class_attribute_defined?).to be true
      end
    end

    context 'if class_attribute is not set' do
      it 'should return false' do
        expect(subject.class_attribute_defined?).to be false
      end
    end
  end

  describe '#reset_class_attribute' do
    before { subject.class_attribute = :play }

    it 'should reset the class attribute' do
      expect { subject.reset_class_attribute }
        .to change { subject.class_attribute }.to(nil)
    end
  end

  describe '#add_attributes' do
    it 'should add the numbers of attributes given in the block' do
      instances = Weka::Core::Instances.new

      expect {
        instances.add_attributes do
          numeric 'attribute'
          nominal 'class', values: ['YES', 'NO']
        end
      }.to change { instances.attributes.count }.from(0).to(2)
    end

    it 'should add the types of attributes given in the block' do
      instances = Weka::Core::Instances.new

      instances.add_attributes do
        numeric 'attribute'
        nominal 'class', values: ['YES', 'NO']
      end

      expect(instances.attributes.map(&:name)).to eq ['attribute', 'class']
    end
  end

  describe '#initialize' do
    it 'should take a relation_name as argument' do
      name = 'name'
      instances = Weka::Core::Instances.new(relation_name: name)

      expect(instances.relation_name).to eq name
    end

    it 'should have a default relation_name of "Instances"' do
      expect(Weka::Core::Instances.new.relation_name).to eq 'Instances'
    end

    it 'should take attributes as argument' do
      attributes = subject.attributes
      instances  = Weka::Core::Instances.new(attributes: attributes)

      expect(instances.attributes.count).to eq attributes.count
    end
  end

  describe 'enumerator' do
    before { @result = nil }

    describe '#each' do
      it 'should run a block on each instance' do
        subject.each do |instance|
          @result = instance.value(0) unless @result
        end

        expect(@result).to eq 0.0 # index of nominal value
      end

      context 'without a given block' do
        it 'should return a WekaEnumerator' do
          expect(subject.each)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end

    describe '#each_with_index' do
      it 'should run a block on each instance' do
        subject.each_with_index do |instance, index|
          @result = "#{instance.value(0)}, #{index}" if index == 0
        end

        expect(@result).to eq '0.0, 0' # 0.0 => index of nominal value
      end

      context 'without a given block' do
        it 'should return a WekaEnumerator' do
          expect(subject.each_with_index)
            .to be_kind_of(Java::WekaCore::WekaEnumeration)
        end
      end
    end

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

  describe '#add_instance' do
    it 'should add an instance from given values to the Instances object' do
      data = [:sunny, 70, 80, 'TRUE', :yes]
      subject.add_instance(data)

      expect(subject.instances.last.to_s).to eq data.join(',')
    end

    it 'should add a given instance to the Instances object' do
      data = subject.first
      subject.add_instance(data)

      expect(subject.instances.last.to_s).to eq data.to_s
    end

    it 'should add a given instance with only missing values' do
      data = Weka::Core::DenseInstance.new(subject.size)
      subject.add_instance(data)
      expect(subject.instances.last.to_s).to eq data.to_s
    end

    it 'should add a given instance with partly missing values' do
      data = [:sunny, 70, nil, '?', Float::NAN]
      subject.add_instance(data)

      expect(subject.instances.last.to_s).to eq 'sunny,70,?,?,?'
    end
  end

  describe '#add_instances' do
    let(:data) do
      [[:sunny, 70, 80, :TRUE, :yes], [:overcast, 80, 85, :FALSE, :yes]]
    end

    it 'should add the data to the Instances object' do
      expect { subject.add_instances(data) }
        .to change { subject.instances_count }
        .by(data.count)
    end

    it 'should call #add_instance internally' do
      expect(subject).to receive(:add_instance).exactly(data.count).times
      subject.add_instances(data)
    end
  end

  describe '#internal_values_of' do
    it 'should return the internal values of the given values' do
      values          = [:sunny, 85, 85, :FALSE, :no]
      internal_values = [0, 85.0, 85.0, 1, 1]

      expect(subject.internal_values_of(values)).to eq internal_values
    end
  end

  describe '#apply_filter' do
    let(:filter) { double('filter') }
    before { allow(filter).to receive(:filter).and_return(subject) }

    it 'should call the given filter‘s #filter method' do
      expect(filter).to receive(:filter).once.with(subject)
      subject.apply_filter(filter)
    end
  end

  describe '#apply_filters' do
    let(:filter) { double('filter') }
    before { allow(filter).to receive(:filter).and_return(subject) }

    it 'should call the given filters‘ #filter methods' do
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
      it 'should call .merge_instance of Weka::Core::Instances' do
        expect(Weka::Core::Instances)
          .to receive(:merge_instances)
          .with(instances_a, instances_b)

        instances_a.merge(instances_b)
      end

      it 'should return the result of .merge_instance' do
        merged = double('instances')
        allow(Weka::Core::Instances).to receive(:merge_instances).and_return(merged)

        expect(instances_a.merge(instances_b)).to eq merged
      end
    end

    context 'when merging multiple instances' do
      it 'should call .merge_instances mutliple times' do
        expect(Weka::Core::Instances).to receive(:merge_instances).twice
        instances_a.merge(instances_b, instances_c)
      end

      it 'should return the merged instances' do
        merged            = instances_a.merge(instances_b, instances_c)
        merged_attributes = [attribute_a, attribute_b, attribute_c]

        expect(merged.attributes).to match_array merged_attributes
      end
    end
  end

end
