module Weka
  module Clusterers
    java_import 'weka.clusterers.ClusterEvaluation'

    class ClusterEvaluation

      alias :summary        :cluster_results_to_string
      alias :clusters_count :num_clusters
    end

    Java::WekaClusterers::ClusterEvaluation.__persistent__ = true

  end
end
