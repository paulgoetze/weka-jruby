require 'weka/class_builder'

module Weka
  module Clusterers
    include ClassBuilder

    build_classes :SimpleKMeans,
                  :FarthestFirst,
                  :EM,
                  :HierarchicalClusterer,
                  :Cobweb
  end
end
