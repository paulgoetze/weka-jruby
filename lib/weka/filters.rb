Weka.require_all :filters

require 'weka/class_builder'

module Weka
  module Filters
    include ClassBuilder

    build_classes :CheckSource,
                  :Filter,
                  :MultiFilter,
                  :RenameRelation,
                  :SimpleBatchFilter,
                  :SimpleFilter,
                  :SimpleStreamFilter
  end
end
