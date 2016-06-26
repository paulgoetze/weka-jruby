require 'weka/core/converters'

module Weka
  module Core
    class Loader
      java_import 'java.io.File'

      class << self
        def load_arff(file)
          load_with(Converters::ArffLoader, file: file)
        end

        def load_csv(file)
          load_with(Converters::CSVLoader, file: file)
        end

        def load_json(file)
          load_with(Converters::JSONLoader, file: file)
        end

        # Takes either a *.names or a *.data file and loads the respective other
        # file from the same directory automatically.
        # Returns a Weka::Core::Instances object.
        #
        # See http://www.cs.washington.edu/dm/vfml/appendixes/c45.htm for more
        # information about the C4.5 file format.
        def load_c45(file)
          load_with(Converters::C45Loader, file: file)
        end

        private

        def load_with(loader_class, file:)
          loader        = loader_class.new
          loader.source = File.new(file)
          loader.data_set
        end
      end
    end
  end
end
