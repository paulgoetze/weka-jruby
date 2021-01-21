module Weka
  module Core
    java_import 'weka.core.DenseInstance'

    class DenseInstance
      java_import 'java.util.Date'
      java_import 'java.text.SimpleDateFormat'

      def initialize(data, weight: 1.0)
        if data.is_a?(Integer)
          super(data)
        else
          super(weight, to_java_double(data))
        end
      end

      def attributes
        enumerate_attributes.to_a
      end

      def each_attribute(&block)
        if block_given?
          enumerate_attributes.each(&block)
        else
          enumerate_attributes
        end
      end

      def each_attribute_with_index(&block)
        if block_given?
          enumerate_attributes.each_with_index(&block)
        else
          enumerate_attributes
        end
      end

      def to_a
        to_double_array.each_with_index.map do |value, index|
          value_from(value, index)
        end
      end

      alias values       to_a
      alias values_count num_values

      private

      def to_java_double(values)
        data = values.map do |value|
          ['?', nil].include?(value) ? Float::NAN : value
        end

        data.to_java(:double)
      end

      def value_from(value, index)
        return '?'   if value.nan?
        return value if dataset.nil?

        attribute = attribute_at(index)

        return format_date(value, attribute.date_format) if attribute.date?
        return value if attribute.numeric?
        return attribute.value(value) if attribute.nominal? || attribute.string?
      end

      def attribute_at(index)
        return attributes[index]     unless dataset.class_attribute_defined?
        return class_attribute       if dataset.class_index == index
        return attributes[index - 1] if index > dataset.class_index

        attributes[index]
      end

      def format_date(value, format)
        formatter = SimpleDateFormat.new(format)
        formatter.format(Date.new(value))
      end
    end
  end
end
