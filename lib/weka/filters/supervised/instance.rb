require 'weka/class_builder'

module Weka
  module Filters
    module Supervised
      module Instance
        include ClassBuilder

        build_classes :ClassBalancer,
                      :Resample,
                      :SpreadSubsample,
                      :StratifiedRemoveFolds
      end
    end
  end
end
