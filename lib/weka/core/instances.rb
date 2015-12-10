require 'weka/core/converters'
require 'weka/core/loader'
require 'weka/core/saver'
require 'weka/core/dense_instance'

module Weka
  module Core
    java_import "weka.core.Instances"
    java_import "weka.core.FastVector"

    class Instances

      DEFAULT_RELATION_NAME = 'Instances'

      attr_reader :relation_name

      class << self
        def from_arff(file)
          Loader.load_arff(file)
        end

        def from_csv(file)
          Loader.load_csv(file)
        end

        def from_json(file)
          Loader.load_json(file)
        end
      end

      def initialize(relation_name = DEFAULT_RELATION_NAME, &block)
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
        Saver.save_arff(file: file, instances: self)
      end

      def to_csv(file)
        Saver.save_csv(file: file, instances: self)
      end

      def to_json(file)
        Saver.save_json(file: file, instances: self)
      end

      def numeric(name, class_attribute: false)
        attribute = Attribute.new(name.to_s)
        add_attribute(attribute)
        set_class_attribute(name) if class_attribute
      end

      def nominal(name, values:, class_attribute: false)
        attribute = Attribute.new(name.to_s, Array(values).map(&:to_s))
        add_attribute(attribute)
        set_class_attribute(name) if class_attribute
      end

      def string(name, class_attribute: false)
        attribute = Attribute.new(name.to_s, [])
        add_attribute(attribute)
        set_class_attribute(name) if class_attribute
      end

      def date(name, format: 'yyyy-MM-dd HH:mm', class_attribute: false)
        attribute = Attribute.new(name.to_s, format)
        add_attribute(attribute)
        set_class_attribute(name) if class_attribute
      end

      def set_class_attribute(name)
        ensure_attribute_defined!(name)
        setClass(attribute_with_name(name))
      end

      alias :add_numeric_attribute :numeric
      alias :add_string_attribute  :string
      alias :add_nominal_attribute :nominal
      alias :add_date_attribute    :date
      alias :class_attribute=      :set_class_attribute

      def class_attribute
        classAttribute if class_attribute_defined?
      end

      def class_attribute_defined?
        class_index >= 0
      end

      def add_instance(values, weight: 1.0)
        data     = internal_values_of(values)
        instance = DenseInstance.new(data, weight: weight)

        add(instance)
      end

      def apply_filter(filter)
        filter.filter(self)
      end

      private

      def add_attribute(attribute)
        insert_attribute_at(attribute, attributes.count)
      end

      def ensure_attribute_defined!(name)
        unless attribute_names.include?(name.to_s)
          error   = "\"#{name}\" is not defined."
          hint    = "Only defined attributes can be used as class attribute!"
          message = "#{error} #{hint}"

          raise ArgumentError, message
        end
      end

      def attribute_with_name(name)
        attributes.select { |attribute| attribute.name == name.to_s }.first
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
