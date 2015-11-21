module Weka
  module Core
    java_import "weka.core.DenseInstance"

    class DenseInstance
      java_import "java.util.Date"
      java_import "java.text.SimpleDateFormat"

      def attributes
        enumerate_attributes.to_a
      end

      def each_attribute(&block)
        enumerate_attributes.each { |attribute| yield(attribute) }
      end

      def each_attribute_with_index(&block)
        enumerate_attributes.each_with_index do |attribute, index|
          yield(attribute, index)
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
