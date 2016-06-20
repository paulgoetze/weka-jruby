require 'active_support/concern'

module Weka
  module Filters
    module Utils
      extend ActiveSupport::Concern

      included do
        def filter(instances)
          set_input_format(instances)
          Filter.use_filter(instances, self)
        end
      end
    end
  end
end
