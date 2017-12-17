module Weka
  module Core
    java_import 'weka.core.SerializationHelper'

    class SerializationHelper
      STRUCTURE_FILE_EXTENSION = 'structure'.freeze

      class << self
        original_read = instance_method(:read)
        original_write = instance_method(:write)

        define_method(:read) do |filename|
          object = original_read.bind(self).call(filename)

          structure_filename = structure_file(filename)
          structure_needed = object.respond_to?(:instances_structure)
          structure_available = File.exist?(structure_filename)

          if structure_needed && structure_available
            structure = original_read.bind(self).call(structure_filename)
            object.instances_structure = structure
          end

          object
        end

        define_method(:write) do |filename, object|
          structure_needed = object.respond_to?(:instances_structure)

          if structure_needed && object.instances_structure
            structure_filename = structure_file(filename)
            structure = object.instances_structure
            original_write.bind(self).call(structure_filename, structure)
          end

          original_write.bind(self).call(filename, object)
        end

        alias deserialize read
        alias serialize   write

        private

        def structure_file(filename)
          "#{filename}.#{STRUCTURE_FILE_EXTENSION}"
        end
      end
    end
  end
end
