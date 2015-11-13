require 'weka/core/converters'

module Weka
  module Core
    java_import 'java.io.File'
    java_import "weka.core.SerializationHelper"
    java_import "weka.core.Instances"
    java_import "weka.core.FastVector"

    class Instances

      def initialize
        attributes = FastVector.new
        @positions = []

        yield if block_given?

        @positions.each { |value| attributes.add_element(value) }
        super('Instances', attributes, 0)
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

      private

      def save_data_set_with(saver_const, file:)
        saver           = saver_const.new
        saver.instances = self
        saver.file      = File.new(file)

        saver.write_batch
      end
    end

  end
end
