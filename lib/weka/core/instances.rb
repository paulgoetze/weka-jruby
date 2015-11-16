require 'weka/core/converters'

module Weka
  module Core
    java_import 'java.io.File'
    java_import "weka.core.SerializationHelper"
    java_import "weka.core.Instances"
    java_import "weka.core.FastVector"

    class Instances

      def self.new_with_attributes(&block)
        self.new.add_attributes(&block)
      end

      def initialize
        super('Instances', FastVector.new, 0)
      end

      def attributes
        enumerate_attributes.to_a
      end

      def add_attributes(&block)
        self.instance_eval(&block) if block
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
        attribute = Attribute.new(name)
        add_attribute(attribute)
      end

      def nominal(name, values)
        attribute = Attribute.new(name, values)
        add_attribute(attribute)
      end

      def string(name)
        attribute = Attribute.new(name, [])
        add_attribute(attribute)
      end

      def date(name, format = nil)
        attribute = Attribute.new(name, format || '')
        add_attribute(attribute)
      end

      alias :add_numeric_attribute :numeric
      alias :add_string_attribute  :string
      alias :add_nominal_attribute :nominal
      alias :add_date_attribute    :date

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
    end

  end
end
