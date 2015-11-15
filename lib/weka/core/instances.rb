require 'weka/core/converters'

module Weka
  module Core
    java_import 'java.io.File'
    java_import "weka.core.SerializationHelper"
    java_import "weka.core.Instances"
    java_import "weka.core.FastVector"

    class Instances

      attr_reader :attributes

      def self.new_with_attributes(&block)
        Instances.new('Instances', FastVector.new, 0).add_attributes(&block)
      end

      def initialize
        initialize_attributes
        super('Instances', FastVector.new, 0)
      end

      def add_attributes(&block)
        initialize_attributes
        attributes = FastVector.new

        self.instance_eval(&block) if block

        @attributes.each { |value| attributes.add_element(value) }
        self
      end

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
        attribute = Attribute.new(name.to_java(:string))
        add_attribute(attribute)
      end

      def nominal(name, *options)
        attribute = Attribute.new(name.to_java(:string), *options)
        add_attribute(attribute)
      end

      def string(name)
        attribute = Attribute.new(name.to_java(:string))
        add_attribute(attribute)
      end

      def date(name, format = nil)
        attribute = Attribute.new(name.to_java(:string), format || '')
        add_attribute(attribute)
      end

      alias :add_numeric_attribute :numeric
      alias :add_string_attribute  :string
      alias :add_nominal_attribute :nominal
      alias :add_date_attribute    :date

      private

      def initialize_attributes
        @attributes = []
      end

      def save_data_set_with(saver_const, file:)
        saver           = saver_const.new
        saver.instances = self
        saver.file      = File.new(file)

        saver.write_batch
      end

      def add_attribute(attribute)
        @attributes << attribute
      end
    end

  end
end
