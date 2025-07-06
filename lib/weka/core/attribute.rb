require 'weka/concerns/persistent'

module Weka
  module Core
    java_import 'weka.core.Attribute'

    class Attribute
      include Weka::Concerns::Persistent

      TYPES = %i[numeric nominal string date].freeze

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
        #
        # The object returned from Java constructor only has class
        # Java::JavaObject so we need to cast it to the proper class
        #
        # See also:
        # https://stackoverflow.com/questions/1792495/casting-objects-in-jruby
        def new_string(name)
          constructor = Attribute.java_class.declared_constructor(
            java.lang.String,
            java.util.List
          )

          constructor.new_instance(name.to_s, nil).to_java(Attribute)
        end
      end

      def values
        enumerate_values.to_a
      end

      ##
      # Returns the string representation of the attribute's type.
      # Overwrites the weka.core.Attribute type Java method, which returns an
      # integer representation of the type based on the defined type constants.
      def type
        self.class.type_to_string(self)
      end

      ##
      # The order of the if statements is important here, because a date is also
      # a numeric.
      def internal_value_of(value)
        return value                  if value.respond_to?(:nan?) && value.nan?
        return Float::NAN             if [nil, '?'].include?(value)
        return parse_date(value.to_s) if date?
        return value.to_f             if numeric?

        index_of_value(value.to_s) if nominal? || string?
      end
    end
  end
end
