require 'weka/concerns'

module Weka
  module Clusterers
    java_import 'weka.clusterers.ClusterEvaluation'

    class ClusterEvaluation
      include Concerns::Persistent

      alias summary        cluster_results_to_string
      alias clusters_count num_clusters
    end
  end
end
