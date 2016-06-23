module Weka
  module Core
    java_import 'weka.core.Attribute'

    class Attribute
      def values
        enumerate_values.to_a
      end

      # The order of the if statements is important here, because a date is also
      # a numeric.
      def internal_value_of(value)
        return value                      if value === Float::NAN
        return Float::NAN                 if [nil, '?'].include?(value)
        return parse_date(value.to_s)     if date?
        return value.to_f                 if numeric?
        return index_of_value(value.to_s) if nominal?
      end
    end

    Weka::Core::Attribute.__persistent__ = true
  end
end
