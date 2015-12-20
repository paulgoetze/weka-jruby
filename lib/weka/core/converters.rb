require 'weka/class_builder'

module Weka
  module Core
    module Converters
      include ClassBuilder

      build_classes :ArffLoader,
                    :ArffSaver,
                    :CSVLoader,
                    :CSVSaver,
                    :JSONLoader,
                    :JSONSaver,
                    include_concerns: false
    end
  end
end
