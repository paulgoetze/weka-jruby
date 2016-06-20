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
