require 'weka/core/converters'

module Weka
  module Core
    class Saver
      java_import 'java.io.File'

      class << self
        def save_arff(file:, instances:)
          save_with(Converters::ArffSaver, file: file, instances: instances)
        end

        def save_csv(file:, instances:)
          save_with(Converters::CSVSaver, file: file, instances: instances)
        end

        def save_json(file:, instances:)
          save_with(Converters::JSONSaver, file: file, instances: instances)
        end

        # Saves the given `instances` into a file with the given name and a
        # *.data file in the same directory.
        # The file with the given file name includes the instances's attribute
        # values, the *.data file holds the actual data.
        #
        # Example:
        #
        #   Weka::Core::Saver.save_c45(
        #     file: './path/to/example.names',
        #     instances: instances
        #   )
        #
        # creates an example.names file and an example.data file in the
        # ./path/to/ directory.
        #
        # See: http://www.cs.washington.edu/dm/vfml/appendixes/c45.htm for more
        # information about the C4.5 file format.
        def save_c45(file:, instances:)
          save_with(Converters::C45Saver, file: file, instances: instances)
        end

        private

        def save_with(saver_class, file:, instances:)
          saver           = saver_class.new
          saver.instances = instances
          saver.file      = File.new(file)

          saver.write_batch
        end
      end
    end
  end
end
