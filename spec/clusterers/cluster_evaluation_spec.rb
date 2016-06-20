require 'spec_helper'

describe Weka::Clusterers::ClusterEvaluation do
  it { is_expected.to be_kind_of(Java::WekaClusterers::ClusterEvaluation) }

  describe 'aliases:' do
    {
      summary:        :cluster_results_to_string,
      clusters_count: :num_clusters
    }.each do |alias_method, method|
      it "should define the alias ##{alias_method} for ##{method}" do
        expect(subject.method(method)).to eq subject.method(alias_method)
      end
    end
  end
end
