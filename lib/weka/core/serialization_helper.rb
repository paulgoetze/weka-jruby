module Weka
  module Core
    java_import 'weka.core.SerializationHelper'

    class SerializationHelper

      class << self
        alias :deserialize :read
        alias :serialize   :write
      end
    end
  end
end
