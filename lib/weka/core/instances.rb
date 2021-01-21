require 'matrix'
require 'weka/core/converters'
require 'weka/core/loader'
require 'weka/core/saver'
require 'weka/core/dense_instance'
require 'weka/concerns/serializable'

module Weka
  module Core
    java_import 'weka.core.Instances'
    java_import 'weka.core.FastVector'

    class Instances
      include Weka::Concerns::Persistent
      include Weka::Concerns::Serializable

      DEFAULT_RELATION_NAME = 'Instances'.freeze

      class << self
        def from_arff(file)
          Loader.load_arff(file)
        end

        def from_csv(file)
          Loader.load_csv(file)
        end

        def from_json(file)
          Loader.load_json(file)
        end

        # Loads instances based on a given *.names file (holding the attribute
        # values) or a given *.data file (holding the attribute values).
        # The respective other file is loaded from the same directory.
        #
        # See http://www.cs.washington.edu/dm/vfml/appendixes/c45.htm for more
        # information about the C4.5 file format.
        def from_c45(file)
          Loader.load_c45(file)
        end
      end

      def initialize(relation_name: DEFAULT_RELATION_NAME, attributes: [])
        attribute_list = FastVector.new
        attributes.each { |attribute| attribute_list.add_element(attribute) }

        super(relation_name.to_s, attribute_list, 0)
      end

      def copy
        constructor = Instances.java_class.declared_constructor(Instances)
        constructor.new_instance(self).to_java(Instances)
      end

      def instances
        enumerate_instances.to_a
      end

      def attributes(include_class_attribute: false)
        attrs = enumerate_attributes.to_a

        class_available = include_class_attribute && class_attribute_defined?
        attrs.insert(class_index, class_attribute) if class_available

        attrs
      end

      def attribute_names(include_class_attribute: false)
        attributes(include_class_attribute: include_class_attribute).map(&:name)
      end

      def add_attributes(&block)
        instance_eval(&block) if block
        self
      end

      alias with_attributes       add_attributes
      alias instances_count       num_instances
      alias attributes_count      num_attributes
      alias has_string_attribute? check_for_string_attributes

      # Check if the instances has any attribute of the given type
      # @param [String, Symbol, Integer] type type of the attribute to check
      #   String and Symbol argument are converted to corresponding type
      #   defined in Weka::Core::Attribute
      #
      # @example Passing String
      #   instances.has_attribute_type?('string')
      #   instances.has_attribute_type?('String')
      #
      # @example Passing Symbol
      #   instances.has_attribute_type?(:String)
      #
      # @example Passing Integer
      #   instances.has_attribute_type?(Attribute::STRING)
      def has_attribute_type?(type)
        type = map_attribute_type(type) unless type.is_a?(Integer)
        check_for_attribute_type(type)
      end

      def each(&block)
        if block_given?
          enumerate_instances.each(&block)
        else
          enumerate_instances
        end
      end

      def each_with_index(&block)
        if block_given?
          enumerate_instances.each_with_index(&block)
        else
          enumerate_instances
        end
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

      def to_arff(file)
        Saver.save_arff(file: file, instances: self)
      end

      def to_csv(file)
        Saver.save_csv(file: file, instances: self)
      end

      def to_json(file)
        Saver.save_json(file: file, instances: self)
      end

      # Creates a file with the istances's attribute values and a *.data file
      # with the actual data.
      #
      # You should choose another file extension than .data (preferably
      # *.names) for the file, else it will just be overwritten with the
      # automatically created *.data file.
      #
      # See http://www.cs.washington.edu/dm/vfml/appendixes/c45.htm for more
      # information about the C4.5 file format.
      def to_c45(file)
        Saver.save_c45(file: file, instances: self)
      end

      def numeric(name, class_attribute: false)
        attribute = Attribute.new_numeric(name)
        add_attribute(attribute)
        self.class_attribute = name if class_attribute
      end

      def nominal(name, values:, class_attribute: false)
        attribute = Attribute.new_nominal(name, values)
        add_attribute(attribute)
        self.class_attribute = name if class_attribute
      end

      def string(name, class_attribute: false)
        attribute = Attribute.new_string(name)
        add_attribute(attribute)
        self.class_attribute = name if class_attribute
      end

      def date(name, format: 'yyyy-MM-dd HH:mm', class_attribute: false)
        attribute = Attribute.new_date(name, format)
        add_attribute(attribute)
        self.class_attribute = name if class_attribute
      end

      def class_attribute=(name)
        if name.nil?
          reset_class_attribute
        else
          ensure_attribute_defined!(name)
          setClass(attribute_with_name(name))
        end
      end

      alias add_numeric_attribute numeric
      alias add_string_attribute  string
      alias add_nominal_attribute nominal
      alias add_date_attribute    date

      def class_attribute
        classAttribute if class_attribute_defined?
      end

      def reset_class_attribute
        set_class_index(-1)
      end

      def class_attribute_defined?
        class_index >= 0
      end

      # Add new instance
      # @param [Instance, Array, Hash] instance_or_values the attribute values
      #   of the instance to be added. If passing an array, the attribute values
      #   must be in the same order as the attributes defined in Instances.
      #   If passing a hash, The keys are the names of the attributes and their
      #   values are corresponding attributes values.
      #
      # @example Passing Instance
      #   instances.add_instance(instance)
      #
      # @example Passing an array of attribute values
      #   attr_values = [attr1_value, attr2_value, attr3_value]
      #   instances.add_instance(attr_values)
      #
      # @example Passing a hash of attribute values.
      #   attr_values = { attr1_name: attr1_value, attr2_name: attr2_value }
      #   instances.add_instance(attr_values)
      #
      def add_instance(instance_or_values, weight: 1.0)
        instance = instance_from(instance_or_values, weight: weight)
        add(instance)
      end

      def add_instances(data, weight: 1.0)
        data.each { |values| add_instance(values, weight: weight) }
      end

      # Retrieve the internal floating point values used to represent
      #   the attributes.
      #
      # @param [Array, Hash] values the attribute values whose floating
      #   point representation should be retrieved.
      #
      # @return [Array, Hash] an array of the internal floating point
      #   representation if the input is an Array. Hash otherwise.
      def internal_values_of(values)
        use_hash = values.is_a?(Hash)
        values = attribute_values_from_hash(values) if use_hash

        values = values.map.with_index do |value, index|
          attribute(index).internal_value_of(value)
        end

        values = attribute_values_to_hash(values) if use_hash
        values
      end

      def apply_filter(filter)
        filter.filter(self)
      end

      def apply_filters(*filters)
        filters.inject(self) do |filtered_instances, filter|
          filter.filter(filtered_instances)
        end
      end

      def merge(*instances)
        instances.inject(self) do |merged_instances, dataset|
          self.class.merge_instances(merged_instances, dataset)
        end
      end

      # Get the all instances's values as Matrix.
      #
      # @return [Matrix] a Matrix holding the instance's values as rows.
      def to_m
        Matrix[*instances.map(&:values)]
      end

      # Wrap the attribute values for the instance to be added with
      #   an Instance object, if needed. The Instance object is
      #   assigned with the given weight.
      #
      # @param [Instance, Array, Hash] instance_or_values either the
      #   instance object to be added or the attribute values for it.
      #   For the latter case, it accepts an array or a hash.
      #
      # @param [Float] weight the weight for the Instance to be added
      #
      # @return [Instance] the object that contains the given
      #   attribute values.
      def instance_from(instance_or_values, weight: 1.0)
        dataset = string_free_structure

        if instance_or_values.is_a?(Java::WekaCore::Instance)
          instance = instance_or_values
          instance.weight = weight
        else
          data = instance_data(instance_or_values)
          instance = DenseInstance.new(data, weight: weight)
        end

        dataset.add(instance)
        dataset.first
      end

      private

      def add_attribute(attribute)
        insert_attribute_at(attribute, attributes.count)
      end

      def ensure_attribute_defined!(name)
        return if attribute_names(include_class_attribute: true).include?(name.to_s)

        error   = "\"#{name}\" is not defined."
        hint    = 'Only defined attributes can be used as class attribute!'
        message = "#{error} #{hint}"

        raise ArgumentError, message
      end

      def attribute_with_name(name)
        attributes(include_class_attribute: true).find do |attribute|
          attribute.name == name.to_s
        end
      end

      def map_attribute_type(type)
        return -1 unless Attribute::TYPES.include?(type.downcase.to_sym)

        Attribute.const_get(type.upcase)
      end

      def instance_data(values)
        values = attribute_values_from_hash(values) if values.is_a?(Hash)
        data = internal_values_of(values)
        data = check_string_attributes(data, values) if has_string_attribute?
        data
      end

      # Convert a hash whose keys are attribute names and values are attribute
      #   values into an array containing attribute values in the order
      #   of the Instances attributes.
      #
      # @param [Hash] hash a hash whose keys are attribute names and
      #   values are attribute values.
      #
      # @return [Array] an array containing attribute values in the
      #   correct order
      def attribute_values_from_hash(hash)
        names = attribute_names(include_class_attribute: true).map(&:to_sym)
        hash.values_at(*names)
      end

      # Convert an array of attribute values in the same order as Instances
      #   attributes into a hash whose keys are attribute names and values
      #   are corresponding attribute values.
      #
      # @param [Array] values an array containing the attribute values
      #
      # @return [Hash] a hash as described above
      def attribute_values_to_hash(values)
        names = attribute_names(include_class_attribute: true).map(&:to_sym)

        names.each_with_index.inject({}) do |hash, (name, index)|
          hash.update(name => values[index])
        end
      end

      def check_string_attributes(internal_values, attribute_values)
        # string attribute has unlimited range of possible values.
        # Check the return index, if it is -1 then add the value to
        # the attribute before creating the instance
        internal_values.map.with_index do |value, index|
          if value == -1 && attribute(index).string?
            attribute(index).add_string_value(attribute_values[index])
          else
            value
          end
        end
      end
    end
  end
end
