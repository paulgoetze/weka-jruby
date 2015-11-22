require 'weka/core/converters'
require 'weka/core/dense_instance'

module Weka
  module Core
    java_import 'java.io.File'
    java_import "weka.core.SerializationHelper"
    java_import "weka.core.Instances"
    java_import "weka.core.FastVector"

    class Instances

      DEFAULT_RELATION_NAME = 'Instances'

      attr_reader :relation_name

      def initialize(relation_name = DEFAULT_RELATION_NAME)
        @relation_name = relation_name.to_s
        super(@relation_name, FastVector.new, 0)
      end

      def instances
        enumerate_instances.to_a
      end

      def attributes
        enumerate_attributes.to_a
      end

      def attribute_names
        attributes.map(&:name)
      end

      def add_attributes(&block)
        self.instance_eval(&block) if block
        self
      end

      alias :with_attributes  :add_attributes
      alias :instances_count  :num_instances
      alias :attributes_count :num_attributes

      def each
        enumerate_instances.each { |instance| yield(instance) }
      end

      def each_with_index
        enumerate_instances.each_with_index { |instance, index| yield(instance, index) }
      end

      def each_attribute
        enumerate_attributes.each { |attribute| yield(attribute) }
      end

      def each_attribute_with_index
        enumerate_attributes.each_with_index { |attribute, index| yield(attribute, index) }
      end

      def to_arff(file)
        save_data_set_with(Converters::ArffSaver, file: file)
      end

      def to_csv(file)
        save_data_set_with(Converters::CSVSaver, file: file)
      end

      def to_json(file)
        save_data_set_with(Converters::JSONSaver, file: file)
      end

      def numeric(name)
        attribute = Attribute.new(name.to_s)
        add_attribute(attribute)
      end

      def nominal(name, values)
        attribute = Attribute.new(name.to_s, Array(values).map(&:to_s))
        add_attribute(attribute)
      end

      def string(name)
        attribute = Attribute.new(name.to_s, [])
        add_attribute(attribute)
      end

      def date(name, format = nil)
        attribute = Attribute.new(name.to_s, format || 'yyyy-MM-dd HH:mm')
        add_attribute(attribute)
      end

      alias :add_numeric_attribute :numeric
      alias :add_string_attribute  :string
      alias :add_nominal_attribute :nominal
      alias :add_date_attribute    :date

      def add_instance(values, weight: 1.0)
        data     = internal_values_of(values)
        instance = DenseInstance.new(data, weight: weight)

        add(instance)
      end

      private

      def save_data_set_with(saver_const, file:)
        saver           = saver_const.new
        saver.instances = self
        saver.file      = File.new(file)

        saver.write_batch
      end

      def add_attribute(attribute)
        insert_attribute_at(attribute, attributes.count)
      end

      def internal_values_of(values)
        values.each_with_index.map do |value, index|
          attribute(index).internal_value_of(value)
        end
      end
    end

    Java::WekaCore::Instances.__persistent__ = true
  end
end
