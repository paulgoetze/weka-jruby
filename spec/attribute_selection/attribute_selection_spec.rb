require 'spec_helper'

describe Weka::AttributeSelection::AttributeSelection do

  describe 'aliases:' do
    {
      to_results_string:          :summary,
      number_attributes_selected: :selected_attributes_count
    }.each do |method, alias_method|
      it "should define the alias ##{alias_method} for ##{method}" do
        expect(subject.method(method)).to eq subject.method(alias_method)
      end
    end
  end
end
