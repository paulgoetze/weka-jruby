module Weka
  module Core
    java_import "weka.core.DenseInstance"

    class DenseInstance
      java_import "java.util.Date"
      java_import "java.text.SimpleDateFormat"

      def initialize(data, weight: 1.0)
        super(weight, data.to_java(:double))
      end

      def attributes
        enumerate_attributes.to_a
      end

      def each_attribute
        if block_given?
          enumerate_attributes.each { |attribute| yield(attribute) }
        else
          enumerate_attributes
        end
      end

      def each_attribute_with_index
        enumerate_attributes.each_with_index do |attribute, index|
          yield(attribute, index) if block_given?
        end
      end

      def to_a
        to_double_array.each_with_index.map do |value, index|
          attribute = attributes[index]

          if attribute.date?
            format_date(value, attribute.date_format)
          elsif attribute.numeric?
            value
          elsif attribute.nominal?
            attribute.value(value)
          end
        end
      end

      alias :values       :to_a
      alias :values_count :num_values

      private

      def format_date(value, format)
        formatter = SimpleDateFormat.new(format)
        formatter.format(Date.new(value))
      end
    end
  end
end
