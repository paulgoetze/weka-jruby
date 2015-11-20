module Weka
  module Core
    java_import "weka.core.Attribute"

    class Attribute

      def values
        enumerate_values.to_a
      end

      # The order of the if statements is important here, because a date is also
      # a numeric.
      def internal_value_of(value)
        if date?
          parse_date(value)
        elsif numeric?
          value
        elsif nominal?
          index_of_value(value)
        end
      end
    end
  end
end
