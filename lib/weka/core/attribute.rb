module Weka
  module Core
    java_import "weka.core.Attribute"

    class Attribute

      def values
        enumerate_values.to_a
      end
    end
  end
end
