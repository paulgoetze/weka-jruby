module Weka
  module Filters
    module Utils
      java_import 'weka.filters.Filter'

      def filter(instances)
        set_input_format(instances)
        Filter.use_filter(instances, self)
      end
    end
  end
end
