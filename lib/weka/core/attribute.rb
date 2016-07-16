require 'weka/concerns/persistent'

module Weka
  module Core
    java_import 'weka.core.Attribute'

    class Attribute
      include Weka::Concerns::Persistent

      TYPES = %(numeric nominal string date).freeze

      class << self
        def new_numeric(name)
          new(name.to_s)
        end

        def new_nominal(name, values)
          new(name.to_s, Array(values).map(&:to_s))
        end

        def new_date(name, format)
          new(name.to_s, format.to_s)
        end

        ##
        # Creates a new Attribute instance of type string.
        #
        # The java class defines the same constructor:
        # Attribute(java.lang.String, java.util.List<java.lang.String>)
        # for nominal and string attributes and handles the type internally
        # based on the second argument.
        #
        # In Java you would write following code to create a string Attribute:
        #   Attribute attribute = new Attribute("name", (FastVector) null);
        #
        # When we use a similar approach in JRuby:
        #   attribute = Attribute.new('name', nil)
        # then a Java::JavaLang::NullPointerException is thrown.
        #
        # Thus, we use refelection here and call the contructor explicitly, see
        # https://github.com/jruby/jruby/wiki/CallingJavaFromJRuby#constructors
        def new_string(name)
          constructor = Attribute.java_class.declared_constructor(
            java.lang.String,
            java.util.List
          )

          constructor.new_instance(name.to_s, nil)
        end
      end

      def values
        enumerate_values.to_a
      end

      ##
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
  end
end
